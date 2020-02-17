//
//  UIActionStateMachineDelegate.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 2/6/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
import Combine

enum PlayerAction {
    case playMinion(minion: MinionInPlay, position: Int)
    case combat(attacker: MinionInPlay, target: MinionInPlay)
    case endTurn
    case concede
}

enum UIActionState {
    case Idle
    case CardSelected(card: Card)
    case MinionSelected(minion: MinionInPlay)
    case PositionSelected(position: Int, minionCard: Card)
    case TargetSelected(target: MinionInPlay, attacker: MinionInPlay)
    case Confirm

    func description() -> String {
        switch self {
        case .Idle:
            return "Ready for action!"
        case .CardSelected(let card):
            return "Selected card \(card.name)"
        case .MinionSelected(let minion):
            return "Selected minion \(minion.name)"
        case .PositionSelected(let position, let minionCard):
            return "Selected board slot \(position) to play \(minionCard.name)"
        case .TargetSelected(let target, let attacker):
            return "selected \(attacker.name) to attack \(target.name)"
        case .Confirm:
            return "Confirmed"
        }
    }
}

struct CombatAction {
    let attacker: MinionInPlay
    let target: MinionInPlay
}

struct PlayMinionAction {
    let player: Player
    let minionCard: Card
    let position: Int
}

protocol UIActionStateMachineDelegate: AnyObject {
    func stateDidChange(state: UIActionState)
}

class ViewModel: ObservableObject, UIActionStateMachineDelegate {
    @Published var state: UIActionState = .Idle
    var stateMachine: UIActionStateMachine
    
    init() {
        self.stateMachine = UIActionStateMachine()
        self.stateMachine.uiDelegate = self
    }
    
    func stateDidChange(state: UIActionState) {
        switch state {
        case .Confirm:
            stateMachine.enter(state: .Idle)
            return
        default:
            break
        }
        self.state = state
        print(state.description())
    }
}
