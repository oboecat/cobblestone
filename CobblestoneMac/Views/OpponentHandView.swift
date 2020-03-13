//
//  OpponentHandView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 3/12/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct OpponentHandView: View {
    @EnvironmentObject var model: ViewModel
    var numberOfCards: Int
    
    let maxWidth = 600
    var spacing: CGFloat {
        get {
            if numberOfCards > 1 {
                return CGFloat(min(-30, (maxWidth - 160 * numberOfCards) / (numberOfCards - 1) ))
            } else {
                return 0
            }
        }
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<numberOfCards, id: \.self) { _ in
                CardBackView()
            }
        }
    }
}

struct OpponentHandView_Previews: PreviewProvider {
    static var previews: some View {
        OpponentHandView(numberOfCards: 2)
    }
}
