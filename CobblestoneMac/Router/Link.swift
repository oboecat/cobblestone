//
//  Link.swift
//  SwitchView
//
//  Created by Abhishek Hingnikar on 4/25/20.
//  Copyright © 2020 Abhishek Hingnikar. All rights reserved.
//

import SwiftUI

struct Link<Content>: View where Content: View {
    @EnvironmentObject var history: NavigationStack
    let to: String
    let content: () -> Content
    let replace: Bool
    
    init (_ to: String, replace: Bool = false, content: @escaping () -> Content) {
        self.to = to
        self.content = content
        self.replace = replace
    }
    
    func navigate() {
        if replace {
            self.history.replace(next: self.to)
        } else {
            self.history.push(next: self.to)
        }
    }
    
    var body: some View {
        Button(action: {
            self.navigate()
        }) {
            content()
        }
    }
}

struct Link_Previews: PreviewProvider {
    static var previews: some View {
        Link("/foo/bar") {
            Text("Hello")
        }.environmentObject(NavigationStack("/"))
    }
}
