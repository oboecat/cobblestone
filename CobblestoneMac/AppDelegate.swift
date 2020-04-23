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
    let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("hello")
        let appViewModel = AppViewModel()
        let contentView = ContentView().environmentObject(appViewModel)
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
    
    func login(completion: @escaping (Credentials?) -> Void) {
//        print("Please enter your email")
//        let email = readLine()!
        let email = "lilapusto@gmail.com"
        
        Auth0
            .authentication()
            .startPasswordless(email: email)
            .start { result in
                switch result {
                case .success:
                    print("Sent OTP to \(email)!")
                case .failure(let error):
                    print(error)
                }
            }
        
        print("Please enter the OTP to log in")
        let code = readLine()!
        Auth0
            .authentication()
            .login(
                email: email,
                code: code,
                audience: "https://game.example.com",
                scope: "openid profile offline_access")
            .start { result in
                switch result {
                case .success(let credentials):
//                    print("access token: \(credentials.accessToken!))")
//                    print("id token: \(credentials.idToken!))")
//                    print("refresh token: \(credentials.refreshToken ?? "none"))")
                    DispatchQueue.main.async {
                        completion(credentials)
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
    }
}
