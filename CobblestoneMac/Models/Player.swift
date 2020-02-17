//
//  Player.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 1/27/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation

class Player: ObservableObject {
    @Published var hand: [Card]
    @Published var deck: [Card]
    @Published var maxMana: Int
    @Published var mana: Int
    
    init(hand: [Card] = [Card.default],
         deck: [Card] = [Card](),
         mana: Int = 1) {
        self.hand = hand
        self.deck = deck
        self.maxMana = mana
        self.mana = mana
    }
}
