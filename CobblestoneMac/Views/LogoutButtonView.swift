//
//  LogoutButtonView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/22/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct LogoutButtonView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        Button(action: {
            self.appViewModel.logout()
        }) {
            Text("Sign out")
        }
    }
}

struct LogoutButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LogoutButtonView()
    }
}
