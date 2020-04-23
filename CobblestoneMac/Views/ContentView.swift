//
//  ContentView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    func damnView() -> AnyView {
        switch appViewModel.userAuthState {
        case .loading:
            return AnyView(LoadingView())
        case .notSignedIn:
            return AnyView(LoginView())
        case .signedIn(let user, _):
            switch appViewModel.authenticatedView {
            case .home:
                return AnyView(HomeView(user: user))
            case .inGame(let game):
                let viewModel = ViewModel(game: game)
                return AnyView(GameView()
                    .environmentObject(game)
                    .environmentObject(viewModel)
                )
            case .none:
                return AnyView(Text("This shouldn't happen"))
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
