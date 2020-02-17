//
//  BoardView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/8/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI
import GameKit

struct BoardView: View {
//    @EnvironmentObject var dropManager: DragAndDrop
    @EnvironmentObject var game: Game
    @EnvironmentObject var model: ViewModel
//    var minionDropZoneDelegates: [MinionDropZoneDelegate]
    let maxWidth = 840.0
    let minionWidth = 120.0
    let spacing = 0.0
    
//    init() {
//        self.minionDropZoneDelegates = [MinionDropZoneDelegate]()
//
//        for i in 0...7 {
//            self.minionDropZoneDelegates.append(MinionDropZoneDelegate(index: i))
//        }
//    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(self.game.redBoard, id: \.name) { minion in
//                MinionPlacementView(dropZone: self.minionDropZoneDelegates[index], index: index)
                MinionInPlayView(minion: minion)
            }
            
//            MinionPlacementView(dropZone: minionDropZoneDelegates[game.redBoard.count], index: game.redBoard.count)
        }
        .frame(width: CGFloat(maxWidth), height: 500)
//        .overlay(
//            HStack(spacing: 0) {
//                Rectangle()
//                    .stroke(Color.pink)
//                    .dropZone(delegate: minionDropZoneDelegates[0])
//
//
//                ForEach(1..<self.game.redBoard.count) { index in
//                    Rectangle()
//                        .stroke(Color.pink)
//                        .dropZone(delegate: self.minionDropZoneDelegates[index])
//                        .frame(width: CGFloat(self.minionWidth + self.spacing))
//                }
//
//                Rectangle()
//                    .stroke(Color.pink)
//                    .dropZone(delegate: minionDropZoneDelegates[game.redBoard.count])
//            }
//        )
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
//            .environmentObject(DragAndDrop())
            .environmentObject(Game.sample())
            .environmentObject(ViewModel())
    }
}
