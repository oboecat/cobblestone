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
            if game.state.activePlayerColor == .red {
                VStack {
                    OpponentHandView(numberOfCards: game.state.bluePlayer.hand.count)
                    SimpleBoardView(friendlyBoard: game.state.board.red, opposingBoard: game.state.board.blue)
                    HStack {
                        CancelButtonView()
                        ConfirmButtonView()
                    }
                    HandView(hand: game.state.redPlayer.hand)
                }
            } else {
                VStack {
                    OpponentHandView(numberOfCards: game.state.redPlayer.hand.count)
                    SimpleBoardView(friendlyBoard: game.state.board.blue, opposingBoard: game.state.board.red)
                    HStack {
                        CancelButtonView()
                        ConfirmButtonView()
                    }
                    HandView(hand: game.state.bluePlayer.hand)
                }
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
