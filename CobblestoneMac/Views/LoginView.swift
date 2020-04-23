//
//  LoginView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/15/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    
    var body: some View {
        VStack {
            Text("You only need to sign in once, fool!")
            TextField("email", text: $email)
            LoginButtonView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
