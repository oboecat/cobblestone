//
//  SwitchContext.swift
//  SwitchView
//
//  Created by Abhishek Hingnikar on 4/24/20.
//  Copyright © 2020 Abhishek Hingnikar. All rights reserved.
//
//
//  SwitchView.swift
//  SwitchView
//
//  Created by Abhishek Hingnikar on 4/24/20.
//  Copyright © 2020 Abhishek Hingnikar. All rights reserved.

import SwiftUI

// @todo: Improve this to reduce the history depth, atm this will become a memory leak
class NavigationStack: ObservableObject {
    @Published var current: String
    private var history = [String]()

    init(_ current: String) {
        self.current = current
    }
    
    func replace(next: String) {
        self.current = next
    }
    
    func push(next: String) {
        self.history.append(next)
        self.current = next
    }
    
    func pop() {
        guard let last = self.history.popLast() else {
            return
        }
        self.current = last
    }
}
