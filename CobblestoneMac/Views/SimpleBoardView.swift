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
    @EnvironmentObject var game: Game
    @EnvironmentObject var model: ViewModel
    let maxWidth = 840.0
    let minionWidth = 120.0
    let spacing = 0.0

    func interactiveMinionView(minion: MinionInPlay) -> AnyView {
        switch self.model.state {
        case .Idle:
            return AnyView(
                Button(action: {
                    self.model.stateMachine.enter(state: .MinionSelected(minion: minion))
                }) {
                    MinionInPlayView(minion: minion)
                }
            )
        case .MinionSelected(let attacker):
            return AnyView(
                Button(action: {
                    self.model.stateMachine.enter(state: .TargetSelected(target: minion, attacker: attacker))
                }) {
                    MinionInPlayView(minion: minion)
                }
            )
        default:
            return AnyView(MinionInPlayView(minion: minion))
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(self.game.redBoard, id: \.name) { minion in
                self.interactiveMinionView(minion: minion)
//                MinionInPlayView(minion: minion)
            }
        }
        .frame(width: CGFloat(maxWidth), height: 500)
    }
}

struct SimpleBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleBoardView()
            .environmentObject(Game.sample())
    }
}
