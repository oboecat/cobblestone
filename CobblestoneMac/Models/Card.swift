//
//  Card.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

struct Card: Codable, Identifiable {
    let id: String
    var name: String
    var cost: Int
    let description: String?
    var minion: Minion
    
    static let `default` = Card(id: "6D63AF30-5A10-485A-B913-C89EE0C42178", name: "Wisp", cost: 0, description: nil, minion: Minion(name: "Wisp", attack: 1, health: 1))
}

extension Card {
    init(minion: Minion, cost: Int, description: String?) {
        self.id = "6D63AF30-5A10-485A-B913-C89EE0C42178"
        self.name = minion.name
        self.cost = cost
        self.description = description
        self.minion = minion
    }
}
