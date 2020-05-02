//
//  ContentView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var appViewModel: AppViewModel = AppViewModel()
    @State var navStack = NavigationStack("/home")
    
    var body: some View {
        switch appViewModel.userAuthState {
        case .notSignedIn:
            return AnyView(LoginView().environmentObject(appViewModel))
        case .signedIn(let user, let manager, let stage):
            return AnyView(Router(self.navStack) {
                Route("/home") {
                    HomeView(user: user)
                }

                Route("/game/:id") { params in
                    GameHostingView(gameId: params["id"]!, credentialsManager: manager)
                }
            }.environmentObject(appViewModel))
        default:
            return AnyView(LoadingView())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
