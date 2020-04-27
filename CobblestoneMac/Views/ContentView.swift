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
    
    func damnView() -> AnyView {
        switch appViewModel.userAuthState {
        case .loading:
            return AnyView(LoadingView())
        case .notSignedIn:
            return AnyView(LoginView().environmentObject(appViewModel))
        case .signedIn(let user, let manager, let stage):
            switch stage {
            case .home:
                return AnyView(HomeView(user: user).environmentObject(appViewModel))
            case .inGame(let id):
                return AnyView(GameHostingView(gameId: id, credentialsManager: manager))
            }
        }
    }
    
    var body: some View {
        damnView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
