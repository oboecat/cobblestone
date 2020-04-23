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
    @Published var state: GameState = GameState.sharedSample
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
                self.state = try! JSONDecoder().decode(GameState.self, from: self.stateData)
                print("\(self.state.redPlayer.hand)")
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
        service.getStateDifference(sinceTurn: state.turn) { diff in
            print("Current turn: \(self.state.turn)")
            if diff != nil {
                self.stateData = try! diff!.apply(to: self.stateData)
                self.state = try! JSONDecoder().decode(GameState.self, from: self.stateData)
            }
            self.isLoading = false
        }
    }
    
    func nextTurn() {
        let action = PlayerAction.endTurn.toAction()
        service.sendAction(action)
//        turn += 1
//
//        switch activePlayerColor {
//        case .red:
//            takeNextTurn(player: &redPlayer)
//            activePlayerColor = .blue
//        case .blue:
//            takeNextTurn(player: &bluePlayer)
//            activePlayerColor = .red
//        }
    }
        
//    private func takeNextTurn(player: inout Player) {
//        if player.maxMana < 10 {
//            player.maxMana += 1
//        }
//
//        player.mana = player.maxMana
//
//        for index in board[player.color].indices {
//            board[player.color, index].attacksRemaining = 1
//        }
//
//        if player.deck.count > 0 {
//            let drawnCard = player.deck.removeFirst()
//            player.hand.append(drawnCard)
//        }
//    }
    
//    func playCard(_ card: Card) {
//        tryPlayMinion(card, position: nil)
//    }
    
    func playMinion(_ card: Card, position: Int?) {
        let player: Player
        
        switch state.activePlayerColor {
        case .red:
            player = state.redPlayer
        case .blue:
            player = state.bluePlayer
        }
        print("\(player.hand)")
        print("\(card.id)")
        if !player.hand.contains(where: { card.id == $0.id }) {
            print("No such card in hand")
            return
        }
        
        if card.cost > player.mana {
            print("Not enough mana")
            return
        }
        
        if state.board[state.activePlayerColor].count >= 7 {
            print("Board is full!")
            return
        }
        
        let action = PlayerAction.playMinion(minionCard: card, position: position ?? 0).toAction()
        service.sendAction(action)
    }
    
//    private func playMinion(for player: inout Player, card: Card, position: Int?) {
//        guard let handIndex = player.hand.firstIndex(where: { card.id == $0.id }) else {
//            return
//        }
//
//        let minion = MinionInPlay(card.minion, color: player.color)
//        player.mana -= card.cost
//        player.hand.remove(at: handIndex)
//
//        if let boardSlot = position, boardSlot < board[player.color].endIndex {
//            board[player.color].insert(minion, at: boardSlot)
//        } else {
//            board[player.color].insert(minion, at: board.red.endIndex)
//        }
//    }
    
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
//
//        var newAttacker = board[attacker.color][board[attacker.color].firstIndex(where: { $0.id == attacker.id })!]
//        var newDefender = board[defender.color][board[defender.color].firstIndex(where: { $0.id == defender.id })!]
//        combat(attacker: &newAttacker, defender: &newDefender)
    }
    
//    private func combat(attacker: inout MinionInPlay, defender: inout MinionInPlay) {
//        attacker.attacksRemaining -= 1
//
//        if attacker.statuses.contains(.stealth) {
//            attacker.statuses.remove(.stealth)
//        }
//
//        if attacker.statuses.contains(.divineShield) {
//            attacker.statuses.remove(.divineShield)
//        } else {
//            attacker.health.damage(by: defender.attack)
//        }
//
//        if defender.statuses.contains(.divineShield) {
//            defender.statuses.remove(.divineShield)
//        } else {
//            defender.health.damage(by: attacker.attack)
//        }
//
//        let defenderIndex = board[defender.color].firstIndex(where: { $0.id == defender.id })!
//        if !defender.health.isAlive() {
//            print("\(defender.name) died")
//            board[defender.color].remove(at: defenderIndex)
//        } else {
//            print("\(defender.name) has \(defender.health.current) health left")
//            board[defender.color][defenderIndex] = defender
//        }
//
//        let attackerIndex = board[attacker.color].firstIndex(where: { $0.id == attacker.id })!
//        if !attacker.health.isAlive() {
//            print("\(attacker.name) died")
//            board[attacker.color].remove(at: attackerIndex)
//        } else {
//            print("\(attacker.name) has \(attacker.health.current) health left")
//            board[attacker.color][attackerIndex] = attacker
//        }
//    }
    
//    private func updateMinion(minion: MinionInPlay) {
//        let index = board[minion.color]!.firstIndex(where: { $0.id == minion.id })!
//        if minion.health.status == .dead {
//            print("\(minion.name) died")
//            board[minion.color]!.remove(at: index)
//        } else {
//            print("\(minion.name) has \(minion.health.current) health left")
//            board[minion.color]![index] = minion
//        }
//    }
}
