//
//  Test.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 5/11/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
import Combine
import Promises

class TestSyncDelegate: SyncDelegate {
    var gameState = GameStateFOW.sharedSample
    
    func stateDidUpdate(state: Decodable) {
        gameState = state as! GameStateFOW
        print("Current state: \(gameState)")
    }
    
//    func test() {
//        let apiClient = GameAPIClient()
//        let syncClient = SyncClient<GameStateFOW>()
//        syncClient.delegate = self
//
//        print("Requesting game")
//        let keyframePromise = apiClient.getGame(id: "0")
//        keyframePromise.then { keyframe -> Promise<Diff> in
//            print("\(keyframe)")
//            syncClient.send(keyframe: keyframe)
//            print("Sending next turn action")
//            return apiClient.sendAction(id: "0", action: PlayerAction.endTurn.toAction())
//        }.then { action in
//            let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
//                print("Getting diff")
//                let diffPromise = apiClient.getGameDiff(id: "0", since: 0)
//                diffPromise.then { diff in
//                    print(diff)
//                    syncClient.send(diff: diff)
//                }
//            }
//        }
//    }

    func testCombine() -> AnyCancellable {
        let apiClient = GameAPIClientCombine()
        let syncClient = SyncClient<GameStateFOW>()
        syncClient.delegate = self
        
        let futureProof = Deferred {
            Future<Int, Never> { promise in
                promise(.success(2))
            }
        }
        
         futureProof
            .sink { number in
                print("\(number)")
            }
        
        let initialState = Deferred { apiClient.getGame(id: "0") }
        let action = Deferred { apiClient.sendAction(id: "0", action: PlayerAction.endTurn.toAction()) }.eraseToAnyPublisher()
        let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect().eraseToAnyPublisher()

        let cancellable = initialState
            .flatMap { keyframe -> AnyPublisher<Diff, Never> in
                syncClient.send(keyframe: keyframe)
                return action
            }
            .map { diff -> AnyPublisher<Date, Never> in
                print("2. Action")
                syncClient.send(diff: diff)
                return timer
            }
            .switchToLatest()
            .flatMap { _ -> AnyPublisher<Diff, Never> in
                print("3. Tick")
                return apiClient.getGameDiff(id: "0", since: 0).eraseToAnyPublisher()
            }
            .sink { diff in // diff stream
                print("Combine diff, gg")
                syncClient.send(diff: diff)
            }
//            .sink(receiveCompletion: { error in
//                    print("\(error)")
//                }, receiveValue: { keyframe in
//                    print("keyframe")
//                }
//            )
        return cancellable
        
//            .sink(
//                receiveCompletion: { completion in
//                    print(completion)
//                },
//                receiveValue: { keyframe in
//                    syncClient.send(keyframe: keyframe)
//                }
//            )
        
        
//        timer
//            .map { _ in
//                apiClient.getGameDiff(id: "0", since: 0)
//            }
//            .switchToLatest()
    }
}
