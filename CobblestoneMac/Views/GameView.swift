//
//  GameView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/17/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var model: ViewModel
    @EnvironmentObject var game: Game
    
    var body: some View {
        HStack {
            VStack {
                OpponentHandView(numberOfCards: game.state.opponent.handCount)
                SimpleBoardView(
                    friendlyBoard: game.state.board[game.state.player.color],
                    enemyBoard: game.state.board[game.state.opponent.color]
                )
                HStack {
                    CancelButtonView()
                    ConfirmButtonView()
                }
                HandView(hand: game.state.player.hand)
            }
            TurnButtonView()
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
