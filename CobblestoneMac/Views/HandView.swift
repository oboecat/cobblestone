//
//  HandView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct HandView: View {
    @EnvironmentObject var model: ViewModel
    var hand: [Card]
    
    let maxWidth = 400
    let spacing = { (handWidth: Int, n: Int) in
        min(-30, CGFloat((handWidth - 160 * n) / (n - 1)))
    }
    
    var body: some View {
        HStack {
            ForEach(hand) { (card: Card) in
                VStack {
                    CardInHandView(card: card)
                        .onTapGesture {
                            self.model.selectCardFromHand(card: card)
                        }
                    Text(card.name)
                }
            }
        }
    }
}

struct HandView_Previews: PreviewProvider {
    static var previews: some View {
        HandView(hand: [Card](minionCollection[0...1]))
            .environmentObject(ViewModel(game: Game.sharedSample))
//            .environmentObject(DragAndDrop())
    }
}
