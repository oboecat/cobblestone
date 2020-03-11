//
//  CardPortraitView.swift
//  Cobblestone
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct MinionPortraitView: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 120, height: 144)
            .clipShape(Ellipse())
            .overlay(Ellipse().stroke(lineWidth: 1))
    }
}

struct MinionPortraitView_Previews: PreviewProvider {
    static var previews: some View {
        MinionPortraitView(image: Image("jerry"))
    }
}

