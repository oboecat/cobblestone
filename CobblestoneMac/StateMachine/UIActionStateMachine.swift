//
//  TurnBuilder.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 1/28/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
import GameKit

struct Action {
    let source: AnyClass
    let target: AnyClass
}

class IdleState: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is CardSelectedState.Type {
           return true
        }
        
        if stateClass is MinionSelectedState.Type {
            return true
        }
        
        if stateClass is EndTurnPreparedState.Type {
            return true
        }

        return false
    }
}

class CardSelectedState: GKState {
    var card: Card?
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is IdleState.Type {
           return true
        }
        
        if stateClass is PositionSelectedState.Type {
            return true
        }

        return false
    }
    
    override func willExit(to nextState: GKState) {
        if let positionSelectedState = nextState as? PositionSelectedState {
            positionSelectedState.minionCard = card!
        }
        card = nil
    }
}

class MinionSelectedState: GKState {
    var minion: MinionInPlay?
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is IdleState.Type {
           return true
        }
        
        if stateClass is TargetSelectedState.Type {
            return true
        }

        return false
    }
    
    override func willExit(to nextState: GKState) {
        if let targetSelectedState = nextState as? TargetSelectedState {
            targetSelectedState.source = minion!
        }
        minion = nil
    }
}

class PositionSelectedState: GKState {
    var minionCard: Card?
    var position: Int?
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is IdleState.Type {
           return true
        }
        
        if stateClass is ConfirmState.Type {
            return true
        }

        return false
    }
    
    override func willExit(to nextState: GKState) {
        if let confirmState = nextState as? ConfirmState {
            confirmState.action = PlayerAction.playMinion(minionCard: minionCard!, position: position!)
        }
        minionCard = nil
        position = nil
    }
}

class TargetSelectedState: GKState {
    var source: MinionInPlay?
    var target: MinionInPlay?
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is IdleState.Type {
           return true
        }
        
        if stateClass is ConfirmState.Type {
            return true
        }

        return false
    }
    
    override func willExit(to nextState: GKState) {
        if let confirmState = nextState as? ConfirmState {
            confirmState.action = PlayerAction.combat(attacker: source!, target: target!)
        }
        source = nil
        target = nil
    }
}

class EndTurnPreparedState: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is IdleState.Type {
            return true
        }
        
        if stateClass is ConfirmState.Type {
            return true
        }
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        // nothing
    }
    
    override func willExit(to nextState: GKState) {
        if let confirmState = nextState as? ConfirmState {
            confirmState.action = PlayerAction.endTurn
        }
    }
}

class ConfirmState: GKState {
    var action: PlayerAction?
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is IdleState.Type {
           return true
        }

        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        // nothing
    }
    
    override func willExit(to nextState: GKState) {
        action = nil
    }
}

class UIActionStateMachine {
    private let stateMachine: GKStateMachine
    weak var uiDelegate: UIActionStateMachineDelegate!
    
    init() {
        self.stateMachine = GKStateMachine(states: [
            IdleState(),
            CardSelectedState(),
            MinionSelectedState(),
            PositionSelectedState(),
            TargetSelectedState(),
            EndTurnPreparedState(),
            ConfirmState()
        ])
        
        self.stateMachine.enter(IdleState.self)
    }
    
    private func validatedNextState<StateType>(_ stateClass: StateType.Type) -> StateType? where StateType: GKState {
        if stateMachine.canEnterState(stateClass) {
            return stateMachine.state(forClass: stateClass)!
        }
        return nil
    }
    
    func enter(state: UIActionState) {
        switch state {
            
        case .idle:
            stateMachine.enter(IdleState.self)
            self.uiDelegate.stateDidChange(state: .idle)
            
        case .cardSelected(let card):
            guard let nextState = validatedNextState(CardSelectedState.self) else { return }
            nextState.card = card
            stateMachine.enter(CardSelectedState.self)
            self.uiDelegate.stateDidChange(state: .cardSelected(card: card))
            
        case .minionSelected(let minion):
            guard let nextState = validatedNextState(MinionSelectedState.self) else { return }
            nextState.minion = minion
            stateMachine.enter(MinionSelectedState.self)
            self.uiDelegate.stateDidChange(state: .minionSelected(minion: minion))
            
        case .positionSelected(let position, _):
            guard let nextState = validatedNextState(PositionSelectedState.self) else { return }
            nextState.position = position
            stateMachine.enter(PositionSelectedState.self)
            self.uiDelegate.stateDidChange(state: .positionSelected(position: position, minionCard: nextState.minionCard!))
            
        case .targetSelected(let target, let attacker):
            guard let nextState = validatedNextState(TargetSelectedState.self) else { return }
            nextState.target = target
            stateMachine.enter(TargetSelectedState.self)
            self.uiDelegate.stateDidChange(state: .targetSelected(target: target, attacker: attacker))
            
        case .endTurnPrepared:
            if !stateMachine.enter(EndTurnPreparedState.self) { return }
            self.uiDelegate.stateDidChange(state: .endTurnPrepared)
            
        case .confirm:
            guard let nextState = validatedNextState(ConfirmState.self) else { return }
            stateMachine.enter(ConfirmState.self)
            self.uiDelegate.stateDidChange(state: .confirm(action: nextState.action!))
        }
    }
}
