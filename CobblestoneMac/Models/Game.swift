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

class Game: ObservableObject {
    @Published var state: GameStateFOW = GameStateFOW.sharedSample
    @Published var isLoading: Bool = false
    var service: GameService
    private var stateData: Data = Data()
    private var pollingTimer: Timer?
    
    init(credentialsManager: CredentialsManager) {
        self.service = GameService(credentialsManager: credentialsManager)
        self.getState()
        self.pollingTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateState), userInfo: nil, repeats: true)
    }
    
    func getState() {
        if isLoading {
            print("Loading already")
            return
        }
        print("Fetching state")
        isLoading = true
        service.getGameState { data in
            if data != nil {
                self.stateData = data!
                self.state = try! JSONDecoder().decode(GameStateFOW.self, from: self.stateData)
                print("\(self.state.player.hand)")
            }
            self.isLoading = false
        }
    }
    
    @objc func updateState() {
        if isLoading {
            print("Loading already")
            return
        }
//        print("Updating state!")
        isLoading = true
        service.getStateDifference(since: state.frameId) { diff in
            print("Current frame: \(self.state.frameId)")
            if diff != nil {
                self.stateData = try! diff!.apply(to: self.stateData)
                self.state = try! JSONDecoder().decode(GameStateFOW.self, from: self.stateData)
            }
            self.isLoading = false
        }
    }
    
    func nextTurn() {
        let action = PlayerAction.endTurn.toAction()
        completeAction(action)
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
        completeAction(action)
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
        completeAction(action)
    }
    
    private func completeAction(_ action: Action) {
        if isLoading {
            print("Loading already")
        }
        isLoading = true
        service.sendAction(action) { diff in
            if diff != nil {
                print("Received action response")
                self.stateData = try! diff!.apply(to: self.stateData)
                self.state = try! JSONDecoder().decode(GameStateFOW.self, from: self.stateData)
            }
            self.isLoading = false
        }
    }
}
