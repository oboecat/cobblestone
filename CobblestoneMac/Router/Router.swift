//
//  Switch.swift
//  SwitchView
//
//  Created by Abhishek Hingnikar on 4/24/20.
//  Copyright © 2020 Abhishek Hingnikar. All rights reserved.
//

import SwiftUI

struct Router<Content>: View where Content: View {
    private let content: () -> Content
    private let ctx: NavigationStack
    
    init(_ ctx: NavigationStack = NavigationStack("/"), @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.ctx = ctx
    }
    
    var body: some View {
        self.content().environmentObject(self.ctx)
    }
}

struct Router_Previews: PreviewProvider {
    static var previews: some View {
        Router (NavigationStack("/foo/bar")) {
            Route ("/foo/bar") { _ in
                VStack {
                    Text("Loading...")
                    Link("/baz") {
                        Text("Goto 2")
                    }
                }
            }

            Route ("/baz") { _ in
                VStack {
                    Text("Please login")
                    Link("3") {
                        Text("/foobar")
                    }
                }
            }

            Route("/foobar") { _ in
                VStack {
                    Text("Ye loggedin")
                    Link("1") {
                        Text("/foo/bar")
                    }
                }
            }
        }
    }
}
