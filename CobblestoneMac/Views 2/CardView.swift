//
//  CardView.swift
//  Cobblestone
//
//  Created by Lila Pustovoyt on 11/2/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct CardView: View {
    var card: Card
    
    var body: some View {
        VStack {
            CardParameterView(value: card.cost, color: .blue)
                .offset(x: -70, y: -25)
                .padding(.bottom, -40)
            
            MinionPortraitView(image: Image("jerry"))
                .offset(y: -50)
                .padding(.bottom, -50)
            
            Text("\(card.name)")
                .font(.headline)
                .offset(y: -35)
                .padding(.bottom, -30)
            
            Text("\(card.description ?? "we know too little to write" )")
                .font(.caption)
                .frame(width: 140, height: 75)
            
            HStack {
                CardParameterView(value: card.minion.attack, color: .orange)
                    .scaleEffect(CGFloat(0.8))
                
                Spacer()
                
                CardParameterView(value: card.minion.health, color: .red)
                    .scaleEffect(CGFloat(0.8))
            }
            .frame(width: 180)
            .offset(y: -25)
        }
        .frame(width: 160, height: 220, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.black, lineWidth: 2)
        )
        .padding(.top, 25)
        .padding(.bottom, 8)
        .padding(.leading, 16)
        .padding(.trailing, 8)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.default)
    }
}
