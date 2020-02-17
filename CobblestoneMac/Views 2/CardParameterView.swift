//
//  CardHealthView.swift
//  Cobblestone
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct CardParameterView: View {
    var value: Int
    var color: Color
    
    var body: some View {
        Text("\(value)")
            .font(.title)
            .fontWeight(.black)
            .bold()
            .foregroundColor(.white)
            .padding(10)
            .background(Circle()
                .foregroundColor(color))
    }
}

struct CardHealthView_Previews: PreviewProvider {
    static var previews: some View {
        CardParameterView(value: 6, color: .red)
    }
}
