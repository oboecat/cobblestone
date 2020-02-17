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

class Minion: Codable {
    var name: String
    var attack: Int
    var health: Int
    var statuses: Set<MinionStatus>?
//    var leader: Int
    
    init(name: String, attack: Int, health: Int, statuses: Set<MinionStatus>?) {
        self.name = name
        self.attack = attack
        self.health = health
        self.statuses = statuses
    }
    
    convenience init(name: String, attack: Int, health: Int) {
        self.init(name: name, attack: attack, health: health, statuses: nil)
    }
    
    static let `default` = Minion(name: "Test", attack: 4, health: 8, statuses: [.taunt, .divineShield])
}

class MinionInPlay: DeathDelegate {
    var name: String
    var attack: Attack
    var health: Health
    var statuses: Set<MinionStatus>
    var attacksRemaining: Int
    
    init(name: String, attack: Int, health: Int, statuses: Set<MinionStatus>?, mustRest: Bool = true) {
        self.name = name
        self.attack = Attack(attack)
        self.health = Health(health)
        
        if let innateStatuses = statuses {
            self.statuses = innateStatuses
        } else {
            self.statuses = []
        }
        
        self.attacksRemaining = self.statuses.contains(.charge) || mustRest == false ? 1 : 0
        
        self.health.delegate = self
    }
    
    convenience init(_ minion: Minion, mustRest: Bool = true) {
        self.init(name: minion.name,
                  attack: minion.attack,
                  health: minion.health,
                  statuses: minion.statuses,
                  mustRest: mustRest)
    }
    
    func canAttack() -> Bool {
        attacksRemaining > 0
    }
    
    func destroy() {
        print("I am dead! \(self)")
    }
    
    static let `default` = MinionInPlay(Minion.default)
}

protocol DeathDelegate: AnyObject {
    func destroy() -> Void
}
