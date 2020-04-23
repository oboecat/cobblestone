//
//  Character.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 12/13/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

@propertyWrapper
struct NonNegative {
    private var number: Int
    
    init() {
        self.number = 0
    }
    
    var wrappedValue: Int {
        get { return number }
        set { number = max(newValue, 0) }
    }
}

struct Attack {
    @NonNegative var current: Int
    @NonNegative var base: Int
    
    init(_ value: Int) {
        self.current = value
        self.base = value
    }
    
    mutating func set(to value: Int) {
        current = value
    }
    
    mutating func change(by value: Int) {
        current += value
    }
}

struct Health: Codable {
    var current: Int
    var max: Int
    var base: Int
    
    init(_ value: Int) {
        self.current = value
        self.max = value
        self.base = value
    }
    
    mutating func damage(by value: Int) {
        current -= value
    }
    
    mutating func heal(by value: Int) {
        current = min(max, current + value)
    }
    
    mutating func set(to value: Int) {
        max = value
        current = value
    }
    
    mutating func buff(by value: Int) {
        max += value
        current += value
    }
    
    mutating func debuff(by value: Int) {
        max -= value
        current = min(current, max)
    }
    
    func isAlive() -> Bool {
        return current > 0
    }
}

extension Health {
    enum CodingKeys: String, CodingKey {
        case current = "_current"
        case max = "_max"
        case base = "_base"
    }
}

class Character {
    var attack: Attack
    var health: Health
//    var frozen: Bool = false
//    var stealthed: Bool = false
//    var immune: Bool = false
//    var windfury: Bool = false
    
    init(attack: Int, health: Int) {
        self.attack = Attack(attack)
        self.health = Health(health)
    }

    func silence() {
        attack.current = attack.base
        
        let dHealth = health.base - health.max
        if dHealth > 0 {
            health.buff(by: dHealth)
        } else {
            health.debuff(by: -dHealth)
        }
    }
    
    func destroy() {
        print("Rest in pieces")
    }
}
