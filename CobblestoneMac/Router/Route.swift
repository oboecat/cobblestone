//
//  Case.swift
//  SwitchView
//
//  Created by Abhishek Hingnikar on 4/24/20.
//  Copyright © 2020 Abhishek Hingnikar. All rights reserved.
//

import SwiftUI

struct Route<Content>: View where Content: View {
    @EnvironmentObject private var history: NavigationStack
    
    private let pattern: String
    private let content: ([String:String]) -> Content

    init(_ pattern: String, content: @escaping ([String:String]) -> Content) {
        self.content = content
        self.pattern = pattern
    }
    
    init(_ pattern: String, content: @escaping () -> Content) {
        self.init(pattern) { _ in
            return content()
        }
    }
    
    var body: some View {
        let capturedParams = matchPath(template: self.pattern, pathStr: self.history.current)
        return Group {
            if (capturedParams != nil) {
                content(capturedParams!)
            }
            EmptyView()
        }
    }
}


//struct Case_Previews: PreviewProvider {
//    static var previews: some View {
//        Case()
//    }
//}
