//
//  Board.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 3/6/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation

struct Board {
    var minions: [[MinionInPlay]]
    
    init(_ minions: [[MinionInPlay]]) {
        self.minions = minions
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
}
