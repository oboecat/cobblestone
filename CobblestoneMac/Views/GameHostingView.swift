//
//  GameHostingView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/23/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI
import Auth0

struct GameHostingView: View {
    var gameId: String
    var credentialsManager: CredentialsManager
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var game: Game
    
    init(gameId: String, credentialsManager: CredentialsManager) {
        self.gameId = gameId
        self.credentialsManager = credentialsManager
        let game = Game(credentialsManager: self.credentialsManager)
        self.game = game
        self.viewModel = ViewModel(game: game)
    }
    
    
    
    var body: some View {
        GameView()
            .environmentObject(viewModel)
            .environmentObject(game)
    }
}

//struct GameHostingView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameHostingView(gameId: 0)
//    }
//}
