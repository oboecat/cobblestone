//
//  CancelButtonView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 2/12/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct CancelButtonView: View {
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        Button(action: {
            self.model.stateMachine.enter(state: .Idle)
        }) {
            Text("Cancel")
        }
    }
}

struct CancelButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CancelButtonView()
    }
}
