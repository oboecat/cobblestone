//
//  GameService.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/6/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

//import Foundation
//import Alamofire
//import Auth0
//import CryptoKit
//import JSONPatch
//import Promises
//
//class GameSyncClient {
//    let gameId = "0"
//    weak var delegate: GameServiceDelegate?
//    unowned var api: GameAPIClient
//    private var credentialsManager: CredentialsManager
//    private var syncState: SyncState<GameStateFOW>!
//    private var pollingTimer: Timer?
//    private var isLoading: Bool = false
//
//    init(credentialsManager: CredentialsManager, api: GameAPIClient) {
//        self.credentialsManager = credentialsManager
//        self.api = api
//        self.getGameState()
//        self.pollingTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.getStateDifference), userInfo: nil, repeats: true)
//    }
//
//    func getGameState() {
//        api.getGame(id: gameId).then { state in
//            guard let decodedState = state.value else {
//                return
//            }
//
//            self.syncState = state
//            self.delegate?.stateDidUpdate(state: decodedState)
//        }
//    }
//
//    @objc func getStateDifference() {
//        api.getGameDiff(id: gameId, since: syncState.id).then { diff in
//            guard let state = self.syncState.patch(with: diff) else {
//                print("No patch for you!")
//                return
//            }
//
//            guard let decodedState = state.value else {
//                return
//            }
//
//            self.syncState = state
//            self.delegate?.stateDidUpdate(state: decodedState)
//        }
//    }
//
//    func sendAction(_ action: Action) {
//        if isLoading == true {
//            print("Loading already!")
//        }
//        isLoading = true
//        self.credentialsManager.credentials { err, credentials in
//            guard err == nil, credentials != nil else {
//                print("Could not retrieve credentials")
//                self.isLoading = false
//                return
//            }
//            print("Sending action \(action)")
//            let headers = self.headers(accessToken: credentials!.accessToken!)
//            AF.request(
//                "http://localhost:3000/game/\(self.gameId)",
//                method: .post,
//                parameters: action,
//                encoder: JSONParameterEncoder.default,
//                headers: headers
//            ).responseDecodable(of: SyncDiff.self) { res in
//                guard let syncDiff = res.value else {
//                    print("\(res.error?.errorDescription ?? "Request failed")")
//                    self.isLoading = false
//                    return
//                }
//
//                guard let syncState = self.syncState.patch(with: syncDiff) else {
//                    print("No patch for you!")
//                    self.isLoading = false
//                    return
//                }
//
//                guard let state = syncState.value else {
//                    self.isLoading = false
//                    return
//                }
//
//                self.syncState = syncState
//                self.isLoading = false
//                self.delegate?.stateDidUpdate(state: state)
//            }
//        }
//    }
//
//    private func headers(accessToken: String) -> HTTPHeaders {
//        return [
//            .authorization(bearerToken: accessToken)
//        ]
//    }
//
//
//}
//
//protocol GameServiceDelegate: AnyObject {
//    func stateDidUpdate(state: GameStateFOW)
//}
//
//
//struct SyncState<T: Decodable>: Decodable {
//    let id: Int
//    private let state: String
//    var value: T? {
//        get {
//            guard let value = try? JSONDecoder().decode(T.self, from: self.state.data(using: .utf8)!) else {
//                print("Invalid state JSON")
//                return nil
//            }
//            return value
//        }
//    }
//
//    func patch(with diff: SyncDiff) -> SyncState? {
//        guard let patch = try? JSONPatch(data: diff.patch.data(using: .utf8)!) else {
//            print("Invalid patch JSON")
//            return nil
//        }
//        guard let patchedState = try? patch.apply(to: self.state.data(using: .utf8)!) else {
//            print("Failed to patch state")
//            return nil
//        }
//
//        let hash = SHA256.hash(data: patchedState.base64EncodedData())
//        // This is ridiculous
//        // perhaps they literally want you to walk
//        // over it byte by byte
//        let stringHash = hash.map { String(format: "%02hhx", $0) }.joined() // that's a yikes, bro!
//
//        if (diff.hash != stringHash) {
//            print("Error, string hash is not the same as diff")
//            return nil
//        }
//
//        return SyncState(id: diff.id, state: String(data: patchedState, encoding: .utf8)!)
//    }
//}
//
//struct SyncDiff: Decodable {
//    let id: Int
//    let patch: String
//    let hash: String
//}
