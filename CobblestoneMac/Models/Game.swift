//
//  Game.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/22/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

class Game: ObservableObject {
    @Published var turn: Int = 1
    @Published var redPlayer: Player
    @Published var bluePlayer: Player
    @Published var redBoard: [MinionInPlay]
    @Published var blueBoard: [MinionInPlay]
    
    init(startingTurn: Int,
         redPlayer: Player = Player(),
         bluePlayer: Player = Player(),
         redBoard: [MinionInPlay] = [MinionInPlay](),
         blueBoard: [MinionInPlay] = [MinionInPlay]()) {
        self.turn = startingTurn
        self.redPlayer = redPlayer
        self.bluePlayer = bluePlayer
        self.redBoard = redBoard
        self.blueBoard = blueBoard
    }
    
    static func sample() -> Game {
        return Game(startingTurn: 1,
                    redPlayer: Player(hand: [Card](minionCollection[3...5]), mana: 10),
                    redBoard: minionCollection[6...8].map { MinionInPlay($0.minion, mustRest: false) },
                    blueBoard: minionCollection[9...10].map { MinionInPlay($0.minion, mustRest: false) }
        )
    }
    
    func nextTurn() {
        turn += 1
        
        if redPlayer.maxMana < 10 {
            redPlayer.maxMana += 1
        }
        
        redPlayer.mana = redPlayer.maxMana
        
        for minion in redBoard {
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
        if card.cost <= redPlayer.mana, let index = redPlayer.hand.firstIndex(where: { card.id == $0.id }) {
            let minion = MinionInPlay(card.minion)
            redPlayer.mana -= card.cost
            redPlayer.hand.remove(at: index)
            
            redBoard.insert(minion, at: position > redBoard.endIndex ? redBoard.endIndex : position)
        }
    }
    
    func combat(_ attacker: MinionInPlay, attacking defender: MinionInPlay) {
        var lhs, rhs: [MinionInPlay]
        
        if attacker.health.status == .dead || defender.health.status == .dead {
            return
        }
        
        if redBoard.contains(where: { $0 === attacker }) {
            lhs = redBoard
        } else if blueBoard.contains(where: { $0 === attacker }) {
            lhs = blueBoard
        } else {
            print("Attacking minion is not in play -- wtf?")
            return
        }
        
        if redBoard.contains(where: { $0 === defender }) {
            rhs = redBoard
        } else if blueBoard.contains(where: { $0 === defender }) {
            rhs = blueBoard
        } else {
            print("Defending minion is not in play -- wtf?")
            return
        }
        
        if !attacker.canAttack() {
            print("This minion needs a turn to get ready.")
            return
        }
        
//        if lhs === rhs {
//            print("Allied minions cannot fight!")
//            return
//        }
        
        if defender.statuses.contains(.stealth) {
            print("That minion is Stealthed.")
            return
        }
        
        if !defender.statuses.contains(.taunt) && rhs.contains(where: { $0.statuses.contains(.taunt) }) {
            print("That minion is protected by a Taunt minion.")
            return
        }
        
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
        
        enforceMinionDeath(minion: defender)
        enforceMinionDeath(minion: attacker)
    }
    
    private func enforceMinionDeath(minion: MinionInPlay) {
        if minion.health.status == .dead {
            print("\(minion.name) died")
            if let index = redBoard.firstIndex(where: { $0 === minion }) {
                print("Removing \(minion.name) at \(index)")
                redBoard.remove(at: index)
                return
            }
            
            if let index = blueBoard.firstIndex(where: { $0 === minion }) {
                blueBoard.remove(at: index)
                return
            }
        }
    }
}
