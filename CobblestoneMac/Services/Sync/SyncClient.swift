//
//  SyncClient.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 5/5/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
import Combine
import CryptoKit
import JSONPatch
import Promises

class SyncClient<Output: Decodable> {
    var delegate: SyncDelegate?
    var currentFrameIdx: Int {
        get {
            currentKeyframe.idx
        }
    }
    private var currentKeyframe: Keyframe!
    
    init() {
        
    }
    
    func send(keyframe: Keyframe) {
        print("New keyframe: \(keyframe)")
        currentKeyframe = keyframe
        let output = try! JSONDecoder().decode(Output.self, from: keyframe.value.data(using: .utf8)!)
        if delegate == nil {
            print("No delegate to send new state")
        }
        delegate?.stateDidUpdate(state: output)
    }
    
    func send(diff: Diff) {
        updateFrame(with: diff)
    }
    
    private func updateKeyframe(with diff: Diff) {
        Promise<(Output, Keyframe)>(on: .global(qos: .default)) { resolve, reject in
            
            guard let patchData = diff.patch.data(using: .utf8), let patch = try? JSONPatch(data: patchData) else {
                print("Patch data is corrupted")
                return
            }
            
            guard let patchedFrameData = try? patch.apply(to: self.currentKeyframe.value.data(using: .utf8)!) else {
                print("Failed to patch state")
                return
            }
            
            guard diff.hash == self.getChecksum(for: patchedFrameData) else {
                print("Checksum check failed")
                return
            }
            
            guard let patchedFrameString = String(data: patchedFrameData, encoding: .utf8) else {
                print("Data is corrupted")
                return
            }
            
            guard let output = try? JSONDecoder().decode(Output.self, from: patchedFrameData) else {
                print("Could not decode patched frame JSON")
                return
            }
            
            let keyframe = Keyframe(idx: diff.idx, value: patchedFrameString)
            resolve((output, keyframe))
            
        }.then { output, keyframe in
            self.currentKeyframe = keyframe
            self.delegate?.stateDidUpdate(state: output)
        }
    }
    
    private func getChecksum(for patchedFrameData: Data) -> String {
        let sortedString = String(String(data: patchedFrameData, encoding: .utf8)!.sorted())
        
        let hash = SHA256.hash(data: sortedString.data(using: .utf8)!)
        // This is ridiculous
        // perhaps they literally want you to walk
        // over it byte by byte
        let stringHash = hash.map { String(format: "%02hhx", $0) }.joined() // that's a yikes, bro!
        return stringHash
    }
    
    private func updateFrame(with diff: Diff) {
        print("Updating frame")
        let future = Future<(Output, Keyframe), Never> { promise in
            let patchData = diff.patch.data(using: .utf8)!
            let patch = try? JSONPatch(data: patchData)
            
            let patchedFrameData = try? patch!.apply(to: self.currentKeyframe.value.data(using: .utf8)!)
            if patchedFrameData == nil {
                print("Failed to patch state")
            }
            
            let stringHash = self.getChecksum(for: patchedFrameData!)
            if diff.hash != stringHash {
                print("Checksum check failed")
            }
            print("Computed hash: \(stringHash)")
            print("Received hash: \(diff.hash)")
            
            let patchedFrameString = String(data: patchedFrameData!, encoding: .utf8)
            print("\(patchedFrameString)")
            if patchedFrameString == nil {
                print("Data is corrupted")
            }
            
            let output = try? JSONDecoder().decode(Output.self, from: patchedFrameData!)
            if output == nil {
                print("Could not decode patched frame JSON")
            }
            
            let keyframe = Keyframe(idx: diff.idx, value: patchedFrameString!)
            promise(.success((output!, keyframe)))
        }
        
        future.sink { output, keyframe in
            self.currentKeyframe = keyframe
            if self.delegate == nil {
                print("No delegate to send updated state")
            }
            self.delegate?.stateDidUpdate(state: output)
        }
    }
}

struct Keyframe: Decodable {
    let idx: Int
    let value: String
}

struct Diff: Decodable {
    typealias Hash = String
    let idx: Int
    let patch: String
    let hash: Hash
}

protocol SyncDelegate: AnyObject {
    func stateDidUpdate(state: Decodable)
}

public extension Promise {
//    func decodeJSON<Item>(_ type: Item.Type, _ decoder: JSONDecoder = JSONDecoder()) -> Promise.Then<Promise<Item>> where Item: Decodable {
//        return self.then { data in
//            guard let output = try? JSONDecoder().decode(type, from: data) else {
//                print("Invalid state JSON")
//                return
//            }
//
//        }
//    }
}
