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
            case .positionSelected(let position, let minionCard):
                self.model.stateMachine.enter(state: .confirm(action: .playMinion(minionCard: minionCard, position: position)))
            case .targetSelected(let target, let attacker):
                self.model.stateMachine.enter(state: .confirm(action: .combat(attacker: attacker, target: target)))
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
            .environmentObject(ViewModel(game: Game.sharedSample))
    }
}
