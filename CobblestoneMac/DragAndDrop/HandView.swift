//
//  HandView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct HandView: View {
    @Binding var hand: [Card]
    @EnvironmentObject var model: ViewModel
    
    let maxWidth = 400
    
    let spacing = { (handWidth: Int, n: Int) in
        min(-30, CGFloat((handWidth - 160 * n) / (n - 1)))
    }
    
    func interactiveCardView(card: Card) -> AnyView {
        switch self.model.state {
        case .Idle:
            return AnyView(Button(action: {
                self.model.stateMachine.enter(state: .CardSelected(card: card))
            }) {
                CardInHandView(card: card)
            })
        default:
            return AnyView(CardInHandView(card: card))
        }
    }
    
    var body: some View {
        HStack {
            ForEach(self.hand) { (card: Card) in
                self.interactiveCardView(card: card)
            }
        }
    }
}

struct HandView_Previews: PreviewProvider {
    static var previews: some View {
        HandView(hand: .constant([Card](minionCollection[0...1])))
            .environmentObject(DragAndDrop())
    }
}
