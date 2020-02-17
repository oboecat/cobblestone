//
//  Card.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation


struct Card: Codable, Identifiable, Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let description: String?
    var cost: Int
    var minion: Minion
    
    static let `default` = Self(id: 0, name: "Wisp", description: nil, cost: 0, minion: Minion(name: "Wisp", attack: 1, health: 1))
}
