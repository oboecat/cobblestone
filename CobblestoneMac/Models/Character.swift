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
    private var number: Int = 0
    
    var wrappedValue: Int {
        get { return number }
        set { number = max(newValue, 0) }
    }
}

struct Attack {
    @NonNegative var current: Int
    @NonNegative var base: Int
    
    init(_ value: Int) {
        current = value
        base = value
    }
    
    mutating func set(to value: Int) {
        current = value
    }
    
    mutating func change(by value: Int) {
        current += value
    }
}

struct Health {
    enum Status {
        case alive
        case dead
    }
    
    var current: Int {
        willSet(newValue) {
            if newValue <= 0 {
                status = .dead
                print("bleh! dead")
            } else {
                status = .alive
            }
        }
    }
    var max: Int
    var base: Int
    var status: Status
    weak var delegate: DeathDelegate?
    
    init(_ value: Int) {
        self.current = value
        self.max = value
        self.base = value
        self.status = value > 0 ? .alive : .dead
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
    
    mutating func unbuff(by value: Int) {
        max -= value
        current = min(current, max)
    }
}

class Character: DeathDelegate {
    var attack: Attack
    var health: Health
//    var attackModifiers = [(attack: Int) -> Int]()
//    var healthModifiers = [(currentHealth: Int, maxHealth: Int) -> (Int, Int)]()
    
//    var frozen: Bool = false
//    var stealthed: Bool = false
//    var immune: Bool = false
//    var windfury: Bool = false
    
    init(attack: Int, health: Int) {
        self.attack = Attack(attack)
        self.health = Health(health)
        
        self.health.delegate = self
    }
    
//    func addAttackModifier(modifier: @escaping (Int) -> Int) {
//        attackModifiers.append(modifier)
//        attack.current = modifier(attack.current)
//    }
//
//    func addHealthModifier(modifier: @escaping (Int, Int) -> (Int, Int)) {
//        healthModifiers.append(modifier)
//        (health.current, health.max) = modifier(health.current, health.max)
//    }

    func silence() {
        attack.current = attack.base
        
        let dHealth = health.base - health.max
        if dHealth > 0 {
            health.buff(by: dHealth)
        } else {
            health.unbuff(by: -dHealth)
        }
    }
    
    func destroy() {
        print("Rest in pieces")
    }
    
//    func setFrozen() {
//        frozen = true
//    }
//
//    func setStealthed() {
//        stealthed = true
//    }
//
//    func setImmune() {
//        immune = true
//    }
//
//    func setWindfury() {
//        windfury = true
//    }
}
