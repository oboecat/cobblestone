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
        VStack {
            HStack {
                CancelButtonView()
                ConfirmButtonView()
            }
            SimpleBoardView()
            HandView(hand: $game.redPlayer.hand)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Game.sample())
            .environmentObject(ViewModel())
    }
}
