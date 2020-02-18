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
    case playMinion(minionCard: Card, position: Int)
    case combat(attacker: MinionInPlay, target: MinionInPlay)
    case endTurn
    case concede
}

enum UIActionState {
    case idle
    case cardSelected(card: Card)
    case minionSelected(minion: MinionInPlay)
    case positionSelected(position: Int, minionCard: Card)
    case targetSelected(target: MinionInPlay, attacker: MinionInPlay)
    case confirm(action: PlayerAction)

    func description() -> String {
        switch self {
        case .idle:
            return "Ready for action!"
        case .cardSelected(let card):
            return "Selected card \(card.name)"
        case .minionSelected(let minion):
            return "Selected minion \(minion.name)"
        case .positionSelected(let position, let minionCard):
            return "Selected board slot \(position) to play \(minionCard.name)"
        case .targetSelected(let target, let attacker):
            return "selected \(attacker.name) to attack \(target.name)"
        case .confirm:
            return "Confirmed"
        }
    }
}

//struct CombatAction {
//    let attacker: MinionInPlay
//    let target: MinionInPlay
//}
//
//struct PlayMinionAction {
//    let player: Player
//    let minionCard: Card
//    let position: Int
//}

protocol UIActionStateMachineDelegate: AnyObject {
    func stateDidChange(state: UIActionState)
}

class ViewModel: ObservableObject, UIActionStateMachineDelegate {
    var game: Game
    var stateMachine: UIActionStateMachine
    @Published var state: UIActionState = .idle
    
    init(game: Game) {
        self.game = game
        self.stateMachine = UIActionStateMachine()
        self.stateMachine.uiDelegate = self
    }
    
    func stateDidChange(state: UIActionState) {
        switch state {
        case .confirm(let action):
            playerAction(action: action)
            stateMachine.enter(state: .idle)
            return
        default:
            break
        }
        self.state = state
        print(state.description())
    }
    
    private func playerAction(action: PlayerAction) {
        switch action {
        case .combat(let attacker, let target):
            game.combat(attacker, attacking: target)
        case .playMinion(let minionCard, let position):
            game.playMinion(minionCard, position: position)
        default:
            break
        }
    }
}
