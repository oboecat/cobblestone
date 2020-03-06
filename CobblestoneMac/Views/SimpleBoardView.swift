//
//  BoardView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/8/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI
import GameKit

struct SimpleBoardView: View {
    @EnvironmentObject var model: ViewModel
    var board: [MinionInPlay]
    let maxWidth = 840.0
    let minionWidth = 120.0
    let spacing = 0.0

    var body: some View {
        HStack(spacing: 0) {
            ForEach(self.board, id: \.name) { minion in
                Button(action: {
                    self.model.selectMinionInBattlefield(minion: minion)
                }) {
                    MinionInPlayView(minion: minion)
                }
            }
        }
        .frame(width: CGFloat(maxWidth), height: 500)
    }
}

struct SimpleBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleBoardView(board: Game.sharedSample.board[.red]!)
            .environmentObject(ViewModel(game: Game.sharedSample))
    }
}
