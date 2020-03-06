//
//  Minion.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 12/13/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

enum MinionStatus: String, Codable {
    case taunt, stealth, charge, divineShield
}

struct Minion: Codable {
    var name: String
    var attack: Int
    var health: Int
    var statuses: Set<MinionStatus>?
    
    init(name: String, attack: Int, health: Int, statuses: Set<MinionStatus>?) {
        self.name = name
        self.attack = attack
        self.health = health
        self.statuses = statuses
    }
    
    init(name: String, attack: Int, health: Int) {
        self.init(name: name, attack: attack, health: health, statuses: nil)
    }
    
    static let `default` = Minion(name: "Test", attack: 4, health: 8, statuses: [.taunt, .divineShield])
}

struct MinionInPlay: Identifiable {
    let id: UUID
    var name: String
    var attack: Attack
    var health: Health
    var statuses: Set<MinionStatus>
    var color: PlayerColor
    var attacksRemaining: Int
    
    init(id: UUID = UUID(), name: String, attack: Int, health: Int, statuses: Set<MinionStatus> = [], color: PlayerColor, mustRest: Bool = true) {
        self.id = id
        self.color = color
        self.name = name
        self.attack = Attack(attack)
        self.health = Health(health)
        self.statuses = statuses
        self.attacksRemaining = statuses.contains(.charge) || mustRest == false ? 1 : 0
    }
    
    init(_ minion: Minion, color: PlayerColor, mustRest: Bool = true) {
        self.init(name: minion.name,
                  attack: minion.attack,
                  health: minion.health,
                  statuses: minion.statuses ?? [],
                  color: color,
                  mustRest: mustRest)
    }
    
    init(card: Card, color: PlayerColor, mustRest: Bool = true) {
        let minion = card.minion
        self.init(id: card.id,
                  name: minion.name,
                  attack: minion.attack,
                  health: minion.health,
                  statuses: minion.statuses ?? [],
                  color: color,
                  mustRest: mustRest)
    }
    
    func canAttack() -> Bool {
        attacksRemaining > 0
    }
    
    static let `default` = MinionInPlay(Minion.default, color: .red)
}
