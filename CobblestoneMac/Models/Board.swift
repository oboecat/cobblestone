//
//  Board.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 3/6/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation

struct Board: Codable {
    var minions: [[MinionInPlay]]
    
    var red: [MinionInPlay] {
        get {
            minions[0]
        }
        set {
            minions[0] = newValue
        }
    }
    var blue: [MinionInPlay] {
        get {
            minions[1]
        }
        set {
            minions[1] = newValue
        }
    }
    
    init(_ minions: [[MinionInPlay]]) {
        self.minions = minions
    }
    
    init(red: [MinionInPlay], blue: [MinionInPlay]) {
        self.minions = [red, blue]
    }
    
    init() {
        self.minions = [[], []]
    }
    
    subscript(color: PlayerColor, index: Int) -> MinionInPlay {
        get {
            minions[color.rawValue][index]
        }
        set {
            minions[color.rawValue][index] = newValue
        }
    }
    
    subscript(side: Int, index: Int) -> MinionInPlay {
        get {
            minions[side][index]
        }
        set {
            minions[side][index] = newValue
        }
    }
    
    subscript(color: PlayerColor) -> [MinionInPlay] {
        get {
            minions[color.rawValue]
        }
        set {
            minions[color.rawValue] = newValue
        }
    }
}

extension Board {
    static let test = Board(
        red: minionCollection[6...8].map { MinionInPlay($0.minion, color: .red, mustRest: false) },
        blue: minionCollection[9...10].map { MinionInPlay($0.minion, color: .blue, mustRest: false) }
    )
}
