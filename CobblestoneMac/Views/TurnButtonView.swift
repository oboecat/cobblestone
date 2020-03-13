//
//  NextTurnButtonView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 3/12/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct TurnButtonView: View {
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        Button(action: {
            self.model.endTurn()
        }) {
            Text("End turn")
        }
    }
}

struct TurnButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TurnButtonView()
    }
}
