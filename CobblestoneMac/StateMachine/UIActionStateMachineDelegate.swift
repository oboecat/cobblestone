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
    
    func description() -> String {
        switch self {
        case .combat(let attacker, let target):
            return "\(attacker.name) attacking \(target.name)"
        case .playMinion(let minionCard, let position):
            return "Playing \(minionCard.name) to board slot \(position)"
        case .endTurn:
            return "Ending turn"
        case .concede:
            return "Conceding"
        }
    }
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
    @Published var state: UIActionState = .idle
    private var stateMachine: UIActionStateMachine
    private var game: Game
    
    init(game: Game) {
        self.game = game
        self.stateMachine = UIActionStateMachine()
        self.stateMachine.uiDelegate = self
    }
    
//    func enter(state: UIActionState) {
//        stateMachine.enter(state: state)
//    }
    
    func selectCardFromHand(card: Card) {
        stateMachine.enter(state: .cardSelected(card: card))
    }
    
    func selectMinionInBattlefield(minion: MinionInPlay) {
        switch state {
        case .idle:
            stateMachine.enter(state: .minionSelected(minion: minion))
        case .minionSelected(let attacker):
            stateMachine.enter(state: .targetSelected(target: minion, attacker: attacker))
        default:
            return
        }
    }
    
    func selectBoardPosition(position: Int) {
        switch state {
        case .cardSelected(let minionCard):
            stateMachine.enter(state: .positionSelected(position: position, minionCard: minionCard))
        default:
            return
        }
    }
    
    func confirmPlayerAction() {
        switch state {
        case .targetSelected(let target, let attacker):
            stateMachine.enter(state: .confirm(action: .combat(attacker: attacker, target: target)))
        case .positionSelected(let position, let minionCard):
            stateMachine.enter(state: .confirm(action: .playMinion(minionCard: minionCard, position: position)))
        default:
            print("complete action first")
        }
    }
    
    func cancelPlayerAction() {
        stateMachine.enter(state: .idle)
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
        print(action.description())
        switch action {
        case .combat(let attacker, let target):
            game.tryCombat(attacker, attacking: target)
        case .playMinion(let minionCard, let position):
            game.playMinion(minionCard, position: position)
        default:
            break
        }
    }
}
