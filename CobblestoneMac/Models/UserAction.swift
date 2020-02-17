//
//  Selection.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 1/28/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
import SwiftState

enum UserActionState: StateType {
    case idle
    case cardSelected(Card)
    case minionSelected(MinionInPlay)
    
    static func == (lhs: UserActionState, rhs: UserActionState) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .idle: hasher.combine("idle")
        case let .cardSelected(card): hasher.combine(card.id.hashValue)
        case let .minionSelected(minion): hasher.combine(minion.name)
        }
    }
}

enum UserActionEvent: EventType {
    case selectCard(Card)
    case selectMinion(MinionInPlay)
    case selectMinionPosition(Int)
    case confirm
    case cancel
    
    static func == (lhs: UserActionEvent, rhs: UserActionEvent) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .selectCard(card): hasher.combine(card.id.hashValue)
        case let .selectMinion(minion): hasher.combine(minion.name)
        case let .selectMinionPosition(position): hasher.combine(position.hashValue)
        case .confirm: hasher.combine("confirm")
        case .cancel: hasher.combine("cancel")
        }
    }
}

func testStateMachine() {
    let machine = Machine<UserActionState, UserActionEvent>(state: .idle) { machine in
        
        machine.addRouteMapping { event, fromState, userInfo -> UserActionState? in
            // no route for no-event
            guard let event = event else { return nil }
            
            switch (event, fromState) {
            case let (.selectCard(card), .idle):
                return .cardSelected(card)
            case let (.selectMinion(minion), .idle):
                return .minionSelected(minion)
            case let (.selectMinionPosition(position), .cardSelected(card)):
                return .idle
            default:
                return nil
            }
        }
        
    }

}
