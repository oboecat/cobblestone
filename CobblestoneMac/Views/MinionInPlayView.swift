//
//  MinionInPlayView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 2/8/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
//
//  MinionView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/8/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct MinionInPlayView: View {
    let minion: MinionInPlay
    
    var body: some View {
        ZStack (alignment: .bottom) {
            Ellipse()
                .foregroundColor(.gray)
                .frame(width: 120, height: 144)
            HStack {
                Ellipse()
                    .foregroundColor(.yellow)
                    .frame(width: 20, height: 20)
                    .overlay(Text(
                        "\(self.minion.attack.current)"))
                Spacer()
                Text(self.minion.name).lineLimit(1)
                Spacer()
                Ellipse()
                    .foregroundColor(.red)
                    .frame(width: 20, height: 20)
                    .overlay(Text("\(self.minion.health.current)"))
            }.padding(.vertical)
        }.frame(width: 120, height: 144)
    }
}

struct MinionInPlayView_Previews: PreviewProvider {
    static var previews: some View {
        MinionInPlayView(minion: MinionInPlay.default)
    }
}
