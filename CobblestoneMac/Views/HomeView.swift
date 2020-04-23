//
//  HomeView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/22/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI
import Auth0

struct HomeView: View {
    var user: UserInfo
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Hi my name is \(user.name!)")
                LogoutButtonView()
                Spacer()
            }
            Spacer()
            PlayButtonView()
            Spacer()
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
