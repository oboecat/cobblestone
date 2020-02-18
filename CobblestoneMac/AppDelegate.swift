//
//  AppDelegate.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("hello")
        // Create the SwiftUI view that provides the window contents.
        let game = Game.sample()
        let viewModel = ViewModel(game: game)
        let contentView = ContentView()
//            .environmentObject(DragAndDrop())
            .environmentObject(game)
            .environmentObject(viewModel)

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullScreen, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center() 
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        
        test(game: game, viewModel: viewModel)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

