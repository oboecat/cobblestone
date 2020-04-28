//
//  Game.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/7/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
import JSONPatch
import Auth0

class Game: ObservableObject, GameServiceDelegate {
    @Published var state: GameStateFOW = GameStateFOW.sharedSample
//    @Published var isLoading: Bool = false
    var service: GameService
    
    init(credentialsManager: CredentialsManager) {
        self.service = GameService(credentialsManager: credentialsManager)
        service.delegate = self
    }
    
    func nextTurn() {
        let action = PlayerAction.endTurn.toAction()
        service.sendAction(action)
    }
    
    func playMinion(_ card: Card, position: Int?) {
        if state.player.color != state.activePlayerColor {
           print("It is not my turn yet")
            return
        }
        
        if !state.player.hand.contains(where: { card.id == $0.id }) {
            print("No such card in hand")
            return
        }
        
        if card.cost > state.player.mana {
            print("Not enough mana")
            return
        }
        
        if state.board[state.player.color].count >= 7 {
            print("Board is full!")
            return
        }
        
        let action = PlayerAction.playMinion(minionCard: card, position: position ?? 0).toAction()
        service.sendAction(action)
    }
    
    func tryCombat(_ attacker: MinionInPlay, attacking defender: MinionInPlay) {
        if attacker.color != state.activePlayerColor {
            return
        }
        
        if !attacker.health.isAlive() || !defender.health.isAlive() {
            return
        }
        
        if attacker.color == defender.color {
            print("Allied minions cannot fight")
            return
        }
        
        if !attacker.canAttack() {
            print("This minion needs a turn to get ready.")
            return
        }
        
        if defender.statuses.contains(.stealth) {
            print("That minion is Stealthed.")
            return
        }
        
        if !defender.statuses.contains(.taunt) && state.board[defender.color].contains(where: { $0.statuses.contains(.taunt) }) {
            print("That minion is protected by a Taunt minion.")
            return
        }
        
        let action = PlayerAction.combat(attacker: attacker, target: defender).toAction()
        service.sendAction(action)
    }
    
    func stateDidUpdate(state: GameStateFOW) {
        self.state = state
    }
}
