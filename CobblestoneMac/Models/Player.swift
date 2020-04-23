//
//  Player.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 1/27/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation

enum PlayerColor: Int, Codable {
    case red, blue
}

struct Player: Codable {
    let color: PlayerColor
    var hand: [Card]
    var deck: [Card]
    var maxMana: Int
    var mana: Int
    
    static let red = Player(color: .red, hand: [Card.default], deck: [Card](), mana: 1)
    static let blue = Player(color: .blue, hand: [Card.default], deck: [Card](), mana: 1)
    
    init(color: PlayerColor,
         hand: [Card] = [Card.default],
         deck: [Card] = [Card](),
         mana: Int = 1) {
        self.color = color
        self.hand = hand
        self.deck = deck
        self.maxMana = mana
        self.mana = mana
    }
}
