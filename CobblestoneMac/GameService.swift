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
    private var credentialsManager: CredentialsManager
    
    init(credentialsManager: CredentialsManager) {
        self.credentialsManager = credentialsManager
    }
    
    func getGameState(completion: @escaping (Data?) -> Void) {
//        print("Requesting game state...")
        self.credentialsManager.credentials { err, credentials in
            guard err == nil, credentials != nil else {
                print("Could not retrieve credentials")
                completion(nil)
                return
            }
            let headers = self.headers(accessToken: credentials!.accessToken!)
            AF.request("http://localhost:3000/game/\(self.gameId)", headers: headers).responseData { res in
                if let data = res.data {
                    completion(data)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func getStateDifference(sinceTurn turn: Int, completion: @escaping (JSONPatch?) -> Void) {
//        print("Requesting difference...")
        self.credentialsManager.credentials { err, credentials in
            guard err == nil, credentials != nil else {
                print("Could not retrieve credentials")
                completion(nil)
                return
            }
            let headers = self.headers(accessToken: credentials!.accessToken!)
            AF.request("http://localhost:3000/game/\(self.gameId)?since=\(turn)", headers: headers).responseData { res in
                if let data = res.data {
                    let diff = try? JSONPatch(data: data)
                    completion(diff)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func sendAction(_ action: Action) {
        self.credentialsManager.credentials { err, credentials in
            guard err == nil, credentials != nil else {
                print("Could not retrieve credentials")
                return
            }
            let headers = self.headers(accessToken: credentials!.accessToken!)
            AF.request("http://localhost:3000/game/\(self.gameId)", method: .post, parameters: action, encoder: JSONParameterEncoder.default, headers: headers).responseString { res in
//                print("\(res.debugDescription)")
            }
//            .responseData { res in
//            if let data = res.data {
//                let diff = try? JSONPatch(data: data)
//                completion(diff)
//            } else {
//                completion(nil)
//            }
//        }
        }
    }
    
    private func headers(accessToken: String) -> HTTPHeaders {
        return [
            .authorization(bearerToken: accessToken)
        ]
    }
}
