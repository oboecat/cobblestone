//
//  EnemyPlayer.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/26/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation

struct EnemyPlayer: Codable {
    let color: PlayerColor
    var handCount: Int
    var deckCount: Int
    var maxMana: Int
    var mana: Int
    
    static let `default` = EnemyPlayer(color: .blue, handCount: 3, deckCount: 10, maxMana: 1, mana: 1)
}
