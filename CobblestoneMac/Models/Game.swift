//
//  Game.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/22/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

enum PlayerColor: Int, Codable {
    case red, blue
}

class Game: ObservableObject {
    @Published var redPlayer: Player
    @Published var bluePlayer: Player
    @Published var board: Board
    @Published var turn: Int = 1
    @Published var activePlayerColor: PlayerColor
    
    init(startingTurn: Int,
         redPlayer: Player = Player.red,
         bluePlayer: Player = Player.blue,
         board: Board = Board()) {
        self.redPlayer = redPlayer
        self.bluePlayer = bluePlayer
        self.board = board
        self.turn = startingTurn
        self.activePlayerColor = .red
    }
    
    static let sharedSample = Game(
        startingTurn: 1,
        redPlayer: Player(color: .red, hand: [Card](minionCollection[3...5]), mana: 10),
        board: Board(red: minionCollection[6...8].map { MinionInPlay($0.minion, color: .red, mustRest: false) },
                     blue: minionCollection[9...10].map { MinionInPlay($0.minion, color: .blue, mustRest: false) })
    )
    
    func nextTurn() {
        turn += 1
        
        switch activePlayerColor {
        case .red:
            takeNextTurn(player: &redPlayer)
            activePlayerColor = .blue
        case .blue:
            takeNextTurn(player: &bluePlayer)
            activePlayerColor = .red
        }
    }
    
    private func takeNextTurn(player: inout Player) {
        if player.maxMana < 10 {
            player.maxMana += 1
        }
        
        player.mana = player.maxMana
        
        for index in board[player.color].indices {
            board[player.color, index].attacksRemaining = 1
        }
        
        if player.deck.count > 0 {
            let drawnCard = player.deck.removeFirst()
            player.hand.append(drawnCard)
        }
    }
    
//    func playCard(_ card: Card) {
//        tryPlayMinion(card, position: nil)
//    }
    
    func playMinion(_ card: Card, position: Int?) {
        switch activePlayerColor {
        case .red:
            playMinion(for: &redPlayer, card: card, position: position)
        case .blue:
            playMinion(for: &bluePlayer, card: card, position: position)
        }
    }
    
    private func playMinion(for player: inout Player, card: Card, position: Int?) {
        guard let handIndex = player.hand.firstIndex(where: { card.id == $0.id }) else {
            return
        }
        
        if card.cost <= player.mana {
            let minion = MinionInPlay(card.minion, color: player.color)
            player.mana -= card.cost
            player.hand.remove(at: handIndex)
            
            if let boardSlot = position, boardSlot < board[player.color].endIndex {
                board[player.color].insert(minion, at: boardSlot)
            } else {
                board[player.color].insert(minion, at: board.red.endIndex)
            }
        }
    }
    
    func tryCombat(_ attacker: MinionInPlay, attacking defender: MinionInPlay) {
        if attacker.color != activePlayerColor {
            return
        }
        
        if attacker.health.status == .dead || defender.health.status == .dead {
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
        
        if !defender.statuses.contains(.taunt) && board[defender.color].contains(where: { $0.statuses.contains(.taunt) }) {
            print("That minion is protected by a Taunt minion.")
            return
        }
        
        var newAttacker = board[attacker.color][board[attacker.color].firstIndex(where: { $0.id == attacker.id })!]
        var newDefender = board[defender.color][board[defender.color].firstIndex(where: { $0.id == defender.id })!]
        combat(attacker: &newAttacker, defender: &newDefender)
    }
    
    private func combat(attacker: inout MinionInPlay, defender: inout MinionInPlay) {
        attacker.attacksRemaining -= 1
        
        if attacker.statuses.contains(.stealth) {
            attacker.statuses.remove(.stealth)
        }
        
        if attacker.statuses.contains(.divineShield) {
            attacker.statuses.remove(.divineShield)
        } else {
            attacker.health.damage(by: defender.attack.current)
        }
        
        if defender.statuses.contains(.divineShield) {
            defender.statuses.remove(.divineShield)
        } else {
            defender.health.damage(by: attacker.attack.current)
        }
        
        let defenderIndex = board[defender.color].firstIndex(where: { $0.id == defender.id })!
        if defender.health.status == .dead {
            print("\(defender.name) died")
            board[defender.color].remove(at: defenderIndex)
        } else {
            print("\(defender.name) has \(defender.health.current) health left")
            board[defender.color][defenderIndex] = defender
        }
        
        let attackerIndex = board[attacker.color].firstIndex(where: { $0.id == attacker.id })!
        if attacker.health.status == .dead {
            print("\(attacker.name) died")
            board[attacker.color].remove(at: attackerIndex)
        } else {
            print("\(attacker.name) has \(attacker.health.current) health left")
            board[attacker.color][attackerIndex] = attacker
        }
    }
    
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
