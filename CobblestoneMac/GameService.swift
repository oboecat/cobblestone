//
//  GameService.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/6/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
import Alamofire
import JSONPatch
import Auth0

class GameService {
    let gameId = 0
    weak var delegate: GameServiceDelegate?
    private var credentialsManager: CredentialsManager
    private var syncState: SyncState!
    private var pollingTimer: Timer?
    private var isLoading: Bool = false
    
    init(credentialsManager: CredentialsManager) {
        self.credentialsManager = credentialsManager
        self.getGameState()
        self.pollingTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.getStateDifference), userInfo: nil, repeats: true)
    }
    
    func getGameState() {
        if isLoading == true {
            print("Loading already!")
            return
        }
        isLoading = true
        self.credentialsManager.credentials { err, credentials in
            guard err == nil, credentials != nil else {
                print("Could not retrieve credentials")
                return
            }
            print(credentials!.accessToken!)
            let headers = self.headers(accessToken: credentials!.accessToken!)

            AF.request(
                "http://localhost:3000/game/\(self.gameId)",
                headers: headers
            ).responseDecodable(of: SyncState.self) { res in
                guard let syncState = res.value else {
                    print("\(res.error?.errorDescription ?? "Request failed")")
                    return
                }
                guard let state = try? JSONDecoder().decode(GameStateFOW.self, from: syncState.state.data(using: .utf8)!) else {
                    print("Invalid state JSON")
                    return
                }
                self.syncState = syncState
                self.isLoading = false
                self.delegate?.stateDidUpdate(state: state)
            }
        }
    }
    
    @objc func getStateDifference() {
        if isLoading == true {
            print("Loading already!")
            return
        }
        isLoading = true
        self.credentialsManager.credentials { err, credentials in
            guard err == nil, credentials != nil else {
                print("Could not retrieve credentials")
                return
            }
            let headers = self.headers(accessToken: credentials!.accessToken!)
            
            AF.request(
                "http://localhost:3000/game/\(self.gameId)?since=\(self.syncState.id)",
                headers: headers
            ).responseDecodable(of: SyncDiff.self) { res in
                guard let syncDiff = res.value else {
                    print("\(res.error?.errorDescription ?? "Request failed")")
                    return
                }
                
                guard let syncState = self.syncState.patch(diff: syncDiff) else {
                    print("No patch for you!")
                    return
                }
                
                guard let state = try? JSONDecoder().decode(GameStateFOW.self, from: syncState.state.data(using: .utf8)!) else {
                    print("Invalid state JSON")
                    return
                }
                
                self.syncState = syncState
                self.isLoading = false
                self.delegate?.stateDidUpdate(state: state)
            }
        }
    }
    
    func sendAction(_ action: Action) {
        if isLoading == true {
            print("Loading already!")
        }
        isLoading = true
        self.credentialsManager.credentials { err, credentials in
            guard err == nil, credentials != nil else {
                print("Could not retrieve credentials")
                return
            }
            print("Sending action \(action)")
            let headers = self.headers(accessToken: credentials!.accessToken!)
            AF.request(
                "http://localhost:3000/game/\(self.gameId)",
                method: .post,
                parameters: action,
                encoder: JSONParameterEncoder.default,
                headers: headers
            ).responseDecodable(of: SyncDiff.self) { res in
                guard let syncDiff = res.value else {
                    print("\(res.error?.errorDescription ?? "Request failed")")
                    return
                }
                
                guard let syncState = self.syncState.patch(diff: syncDiff) else {
                    print("No patch for you!")
                    return
                }
                
                guard let state = try? JSONDecoder().decode(GameStateFOW.self, from: syncState.state.data(using: .utf8)!) else {
                    print("Invalid state JSON")
                    return
                }
                
                self.syncState = syncState
                self.isLoading = false
                self.delegate?.stateDidUpdate(state: state)
            }
        }
    }
    
    private func headers(accessToken: String) -> HTTPHeaders {
        return [
            .authorization(bearerToken: accessToken)
        ]
    }
    
    private struct SyncState: Codable {
        let id: Int
        let state: String
        
        func patch(diff: SyncDiff) -> SyncState? {
            guard let patch = try? JSONPatch(data: diff.patch.data(using: .utf8)!) else {
                print("Invalid patch JSON")
                return nil
            }
            guard let patchedState = try? patch.apply(to: self.state.data(using: .utf8)!) else {
                print("Failed to patch state")
                return nil
            }
            
            return SyncState(id: diff.id, state: String(data: patchedState, encoding: .utf8)!)
        }
    }
    
    private struct SyncDiff: Codable {
        let id: Int
        let patch: String
    }
}

protocol GameServiceDelegate: AnyObject {
    func stateDidUpdate(state: GameStateFOW)
}
