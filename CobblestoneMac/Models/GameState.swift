//
//  GameState.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/22/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

struct GameState: Codable {
    var redPlayer: Player
    var bluePlayer: Player
    var board: Board
    var turn: Int = 1
    var activePlayerColor: PlayerColor
    
    init(startingTurn: Int,
         redPlayer: Player = Player.red,
         bluePlayer: Player = Player.blue,
         board: Board = Board()) {
        self.redPlayer = redPlayer
        self.bluePlayer = bluePlayer
        self.board = board
        self.turn = startingTurn
        self.activePlayerColor = .red
    }
    
    static let sharedSample = GameState(
        startingTurn: 1,
        redPlayer: Player(color: .red, hand: [Card](minionCollection[3...5]), mana: 10),
        board: Board(red: minionCollection[6...8].map { MinionInPlay($0.minion, color: .red, mustRest: false) },
                     blue: minionCollection[9...10].map { MinionInPlay($0.minion, color: .blue, mustRest: false) })
    )
}
