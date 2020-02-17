//
//  Effect.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 12/18/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

protocol Effect {
    func action(source: Character, target: Minion, context: Game) -> Void
}

//struct DealDamage {
//    var value: Int
//    
//    func action(source: Character, target: Minion, context: Game) {
//        target.health.damage(by: value)
//    }
//}
