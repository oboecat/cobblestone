//
//  CardBackView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 3/12/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct CardBackView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(white: 0.35))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black, lineWidth: 2))
            Text("I am a card back")
        }
        .frame(width: 160, height: 220, alignment: .top)
    }
}

struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        CardBackView()
    }
}
