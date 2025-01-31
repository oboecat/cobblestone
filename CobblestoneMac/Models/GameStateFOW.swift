//
//  GameState.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/22/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

struct GameStateFOW: Codable {
    var player: Player
    var opponent: EnemyPlayer
    var board: Board
    var turn: Int = 1
    var activePlayerColor: PlayerColor
    
    init(startingTurn: Int, player: Player, opponent: EnemyPlayer, board: Board) {
        self.player = player
        self.opponent = opponent
        self.board = board
        self.turn = startingTurn
        self.activePlayerColor = .red
    }
    
    static let sharedSample = GameStateFOW(
        startingTurn: 1,
        player: Player.red,
        opponent: EnemyPlayer.default,
        board: Board.default
    )
}
