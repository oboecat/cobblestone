//
//  CardInHandView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/8/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct CardInHandView: View {
    var card: Card
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        CardView(card: card)
//            .draggable(card: $card)
    }
}

struct CardInHandView_Previews: PreviewProvider {
    static var previews: some View {
        CardInHandView(card: Card.default)
            .frame(width: 200, height: 260)
            .environmentObject(DragAndDrop())
    }
}
