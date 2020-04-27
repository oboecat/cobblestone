//
//  AppViewModel.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 4/15/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
import Auth0
import JWTDecode

enum UserAuthState {
    case notSignedIn, signedIn(user: UserInfo, manager: CredentialsManager, stage: AuthenticatedView), loading
}

enum AuthenticatedView {
    case home, inGame(id: Int)
}

class AppViewModel: ObservableObject {
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    @Published var userAuthState: UserAuthState = .loading
    
    init() {
        if !self.credentialsManager.hasValid() {
            self.userAuthState = .notSignedIn
            return
        }
        self.getUserInfo { userInfo in
            DispatchQueue.main.async {
                if let user = userInfo {
                    self.userAuthState = .signedIn(
                        user: user,
                        manager: self.credentialsManager,
                        stage: .home)
                } else {
                    self.userAuthState = .notSignedIn
                }
            }
        }
    }
    
    func getAccessToken(completion: @escaping (String?) -> Void) {
        self.credentialsManager.credentials { err, credentials in
            guard err == nil, credentials != nil else {
                print("Could not retrieve credentials")
                completion(nil)
                return
            }
            completion(credentials!.accessToken!)
        }
    }
    
    func getUserInfo(completion: @escaping (UserInfo?) -> Void) {
        self.credentialsManager.credentials { err, credentials in
            guard err == nil, credentials != nil else {
                print("Could not retrieve credentials")
                completion(nil)
                return
            }
            completion(self.userInfo(credentials!))
        }
    }
    
    func login() {
//        print("Please enter your email")
//        let email = readLine()!
//        let email = "lilapusto@gmail.com"
        
        Auth0
            .webAuth()
            .audience("https://game.example.com")
            .start { result in
                switch result {
                case .success(let credentials):
                    print("Obtained credentials: \(credentials)")
                    self.credentialsManager.store(credentials: credentials)
                    DispatchQueue.main.async {
                        self.userAuthState = .signedIn(
                            user: self.userInfo(credentials),
                            manager: self.credentialsManager,
                            stage: .home)
                    }
                case .failure(let error):
                    print("Failed with \(error)")
                }
        }
        
//        Auth0
//            .authentication()
//            .startPasswordless(email: email)
//            .start { result in
//                switch result {
//                case .success:
//                    print("Sent OTP to \(email)!")
//                case .failure(let error):
//                    print(error)
//                }
//            }
        
//        print("Please enter the OTP to log in")
//        let code = readLine()!
//        Auth0
//            .authentication()
//            .login(
//                email: email,
//                code: code,
//                audience: "https://game.example.com",
//                scope: "openid profile offline_access")
//            .start { result in
//                switch result {
//                case .success(let credentials):
//                    self.credentialsManager.store(credentials: credentials)
//                    DispatchQueue.main.async {
//                        self.userAuthState = .signedIn(user: self.userInfo(credentials), manager: self.credentialsManager)
//                        self.authenticatedView = .home
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
    }
    
    func logout() {
        credentialsManager.revoke { err in
            print(err.debugDescription)
        }
        userAuthState = .notSignedIn
    }
    
    func startGame() {
        switch userAuthState {
        case .signedIn(_, _, var stage):
            stage = .inGame(id: 0)
        default:
            return
        }
    }
    
    private func userInfo(_ credentials: Credentials) -> UserInfo {
        let jwt = try? decode(jwt: credentials.idToken!)
        return UserInfo(json: jwt!.body)!
    }
}
