//
//  PlayButtonView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/22/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct PlayButtonView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        Button(action: {
            switch self.appViewModel.userAuthState {
            case .signedIn(let user, let manager, _):
                self.appViewModel.userAuthState = .signedIn(user: user, manager: manager, stage: .inGame(id: 0))
            default:
                return
            }
        }) {
            Text("Play")
        }
    }
}

//struct PlayButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayButtonView()
//    }
//}
