//
//  MinionMash.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 1/27/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
import SwiftState

func test(game: Game, viewModel: ViewModel) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        print("Testing")
        print("Will play a turn \(game.redPlayer.hand.count) \(game.board[.red]!.count)")
//        game.redBoard.remove(at: 0)
//        game.playCard(game.redPlayer.hand.randomElement()!)
        game.redPlayer.hand[0].name = "test"
        print("Played a turn \(game.redPlayer.hand.count) \(game.board[.red]!.count)")
    }
}
