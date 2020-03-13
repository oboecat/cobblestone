//
//  ContentView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var game: Game
    @EnvironmentObject var model: ViewModel

    var body: some View {
        HStack {
            if game.activePlayerColor == .red {
                VStack {
                    OpponentHandView(numberOfCards: game.bluePlayer.hand.count)
                    SimpleBoardView(friendlyBoard: game.board.red, opposingBoard: game.board.blue)
                    HStack {
                        CancelButtonView()
                        ConfirmButtonView()
                    }
                    HandView(hand: game.redPlayer.hand)
                }
            } else {
                VStack {
                    OpponentHandView(numberOfCards: game.redPlayer.hand.count)
                    SimpleBoardView(friendlyBoard: game.board.blue, opposingBoard: game.board.red)
                    HStack {
                        CancelButtonView()
                        ConfirmButtonView()
                    }
                    HandView(hand: game.bluePlayer.hand)
                }
            }
            TurnButtonView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Game.sharedSample)
            .environmentObject(ViewModel(game: Game.sharedSample))
    }
}
