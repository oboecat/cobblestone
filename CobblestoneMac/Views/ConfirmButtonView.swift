//
//  ConfirmButtonView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 2/12/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct ConfirmButtonView: View {
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        Button(action: {
            switch self.model.state {
            case .PositionSelected, .TargetSelected:
                self.model.stateMachine.enter(state: .Confirm)
            default:
                print("complete action first")
            }
        }) {
            Text("Confirm")
        }
    }
}

struct ConfirmButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmButtonView()
    }
}
