//
//  Hero.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 12/13/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

class Hero: Character {
    var heroClass: String
    var heroPower: String
    var weapon: String?
    var armor: Int
    
    init(attack: Int, health: Int, heroClass: String, heroPower: String, weapon: String?, armor: Int) {
        self.heroClass = heroClass
        self.heroPower = heroPower
        self.weapon = weapon
        self.armor = armor
        super.init(attack: attack, health: health)
    }
    
    convenience init(heroClass: String, heroPower: String, weapon: String?, armor: Int) {
        self.init(attack: 0, health: 30, heroClass: heroClass, heroPower: heroPower, weapon: weapon, armor: armor)
    }
}
