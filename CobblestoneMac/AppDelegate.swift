//
//  AppDelegate.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/7/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Cocoa
import Auth0
import Alamofire
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("hello")
//        let appViewModel = AppViewModel()
        let contentView = ContentView()
//        let game = Game(accessToken: credentials!.accessToken!)
//            let viewModel = ViewModel(game: game)
//            print("Creating view")
        
        // Create the window and set the content view.
        self.window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullScreen, .fullSizeContentView],
            backing: .buffered, defer: false)
        self.window.center()
        self.window.setFrameAutosaveName("Main Window")
        self.window.contentView = NSHostingView(rootView: contentView)
        self.window.makeKeyAndOrderFront(nil)
//        test(viewModel: viewModel)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        return Auth0.resumeAuth(urls)
    }
}
