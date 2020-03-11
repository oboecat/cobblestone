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
    @Published var turn: Int = 1
    @Published var redPlayer: Player
    @Published var bluePlayer: Player
//    @Published var redBoard: [MinionInPlay]
//    @Published var blueBoard: [MinionInPlay]
    @Published var board: [PlayerColor: [MinionInPlay]]
    
    init(startingTurn: Int,
         redPlayer: Player = Player.red,
         bluePlayer: Player = Player.blue,
//         redBoard: [MinionInPlay] = [MinionInPlay](),
//         blueBoard: [MinionInPlay] = [MinionInPlay](),
         board: [PlayerColor: [MinionInPlay]] = [.red: [], .blue: []]) {
        self.turn = startingTurn
        self.redPlayer = redPlayer
        self.bluePlayer = bluePlayer
        self.board = board
    }
    
    static let sharedSample = Game(
        startingTurn: 1,
        redPlayer: Player(color: .red, hand: [Card](minionCollection[3...5]), mana: 10),
//        redBoard: minionCollection[6...8].map { MinionInPlay($0.minion, color: .red, mustRest: false) },
//        blueBoard: minionCollection[9...10].map { MinionInPlay($0.minion, color: .blue, mustRest: false) },
        board: [ .red: minionCollection[6...8].map { MinionInPlay($0.minion, color: .red, mustRest: false) }, .blue: [] ]
    )
    
    func nextTurn() {
        turn += 1
        
        if redPlayer.maxMana < 10 {
            redPlayer.maxMana += 1
        }
        
        redPlayer.mana = redPlayer.maxMana
        
        for var minion in board[.red]! {
            minion.attacksRemaining = 1
        }
        
        if redPlayer.deck.count > 0 {
            let drawnCard = redPlayer.deck.remove(at: 0)
            redPlayer.hand.append(drawnCard)
        }
    }
    
    func playCard(_ card: Card) {
        playMinion(card, position: 0)
    }
    
    func playMinion(_ card: Card, position: Int) {
        if let index = redPlayer.hand.firstIndex(where: { card.id == $0.id }), card.cost <= redPlayer.mana {
            let minion = MinionInPlay(card.minion, color: .red)
            redPlayer.mana -= card.cost
            redPlayer.hand.remove(at: index)
            
            board[.red]!.insert(minion, at: position > board[.red]!.endIndex ? board[.red]!.endIndex : position)
        }
    }
    
    func tryCombat(_ attacker: MinionInPlay, attacking defender: MinionInPlay) {
        if attacker.health.status == .dead || defender.health.status == .dead {
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
        
        if !defender.statuses.contains(.taunt) && board[defender.color]!.contains(where: { $0.statuses.contains(.taunt) }) {
            print("That minion is protected by a Taunt minion.")
            return
        }
        
        var newAttacker = board[attacker.color]![board[attacker.color]!.firstIndex(where: { $0.id == attacker.id })!]
        var newDefender = board[defender.color]![board[defender.color]!.firstIndex(where: { $0.id == defender.id })!]
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
        
        let defenderIndex = board[defender.color]!.firstIndex(where: { $0.id == defender.id })!
        if defender.health.status == .dead {
            print("\(defender.name) died")
            board[defender.color]!.remove(at: defenderIndex)
        } else {
            print("\(defender.name) has \(defender.health.current) health left")
            board[defender.color]![defenderIndex] = defender
        }
        
        let attackerIndex = board[attacker.color]!.firstIndex(where: { $0.id == attacker.id })!
        if attacker.health.status == .dead {
            print("\(attacker.name) died")
            board[attacker.color]!.remove(at: attackerIndex)
        } else {
            print("\(attacker.name) has \(attacker.health.current) health left")
            board[attacker.color]![attackerIndex] = attacker
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
