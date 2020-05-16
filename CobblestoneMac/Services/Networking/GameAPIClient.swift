//
//  GameAPIClient.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 5/2/20.
//  Copyright © 2020 Lila Pustovoyt. All rights reserved.
//

import Foundation
import Combine
import Alamofire
import Auth0
import Promises

typealias Middleware = (_ request: URLRequest) -> URLRequest

/*:
    This assumes that all of our endpoints will *always* return a JSON Response
 */
protocol EndpointProtocol {
    associatedtype ResponseDataType: Decodable
    
    var method: HTTPMethod { get }
    var path: String { get }
    var query: Parameters? { get }
    
    func fetch() -> Promise<ResponseDataType>
    func getHost() -> URL

    var middlewares: [Middleware] {get}
}

extension EndpointProtocol {
    func getHost() -> URL {
        return URL(string: "http://localhost:3000")!
    }

    func fetch() -> Promise<ResponseDataType> {
        return Promise<ResponseDataType> { resolve, reject in
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

            let url = self.getHost().appendingPathComponent(self.path)
            guard var request = try? URLRequest(url: url, method: self.method) else {
                print("Error")
                return
            }
            
            if let requestWithQuery = try? URLEncoding.queryString.encode(request, with: self.query) {
                request = requestWithQuery
            }

            /// At this point we have a request, which we can perhaps extend?
            request = self.middlewares.reduce(request) { tempRequest, middleware in
                middleware(tempRequest)
            }
            
            print("\(request)")
            AF
                .request(request)
                .validate()
                .responseDecodable(of: ResponseDataType.self, decoder: jsonDecoder) {
                    (response: AFDataResponse<ResponseDataType>) in
                    print("Received response")
                    switch response.result {
                        case .success(let value):
                            resolve(value)
                        case .failure(let error):
                            print(error)
                            reject(error)
                    }
                }
        }
    }
}

struct Endpoint<ResponseDataType>: EndpointProtocol where ResponseDataType: Decodable {
    let method: HTTPMethod
    let path: String
    let query: Parameters?
    let middlewares: [(_ request: URLRequest) -> URLRequest]
    
    init( method: HTTPMethod, path: String, query: [String:String]? = nil) {
        self.method = method
        self.path = path
        self.query = query
        self.middlewares = [Middleware]()
    }
}

struct EndpointWithBody<ResponseDataType, BodyDataType>: EndpointProtocol where ResponseDataType: Decodable, BodyDataType: Encodable {
    var method: HTTPMethod
    var path: String
    var query: Parameters?
    var middlewares: [Middleware]
    
    init( method: HTTPMethod, path: String, query: [String: String]? = nil, body: BodyDataType) {
        self.method = method
        self.path = path
        self.query = query
        self.middlewares = [{ try! JSONParameterEncoder().encode(body, into: $0) }]
    }
}

func strangle<T>(_ input: T) -> String {
    return "\(input)"
}

class GameAPIClient {
    init() {
    }
    
    func startGame() -> Promise<GameStateFOW> {
        return Endpoint<GameStateFOW>(method: .get, path: "/start/game").fetch()
    }
    
    func getGame(id: String) -> Promise<Keyframe> {
        let endpoint = Endpoint<Keyframe>(method: .get, path: "/game/\(id)")
        return endpoint.fetch()
    }
    
    func getGameDiff(id: String, since: Int) -> Promise<Diff> {
        return Endpoint<Diff>(method: .get, path:"/game/\(id)", query: [
            "since": strangle(since)
        ]).fetch()
    }
    
    func sendAction(id: String, action: Action) -> Promise<Diff> {
        return EndpointWithBody<Diff, Action>(method: .post, path: "/game/\(id)", body: action).fetch()
    }
}

class GameAPIClientCombine {
    init() {
    }
    
    func startGame() -> Future<GameStateFOW, Never> {
        return Endpoint<GameStateFOW>(method: .get, path: "/start/game").fetchPublisher()
    }
    
    func getGame(id: String) -> Future<Keyframe, Never> {
        return Endpoint<Keyframe>(method: .get, path: "/game/\(id)").fetchPublisher()
    }
    
    func getGameDiff(id: String, since: Int) -> Future<Diff, Never> {
        return Endpoint<Diff>(method: .get, path:"/game/\(id)", query: [
            "since": strangle(since)
        ]).fetchPublisher()
    }
    
    func sendAction(id: String, action: Action) -> Future<Diff, Never> {
        return EndpointWithBody<Diff, Action>(method: .post, path: "/game/\(id)", body: action).fetchPublisher()
    }
}

extension EndpointProtocol {
    func fetchPublisher() -> Future<ResponseDataType, Never> {
        return Future<ResponseDataType, Never> { promise in
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

            let url = self.getHost().appendingPathComponent(self.path)
            var request = try! URLRequest(url: url, method: self.method)
            
            if let requestWithQuery = try? URLEncoding.queryString.encode(request, with: self.query) {
                request = requestWithQuery
            }

            /// At this point we have a request, which we can perhaps extend?
            request = self.middlewares.reduce(request) { tempRequest, middleware in
                middleware(tempRequest)
            }
            
            AF
                .request(request)
                .validate()
                .responseDecodable(of: ResponseDataType.self, decoder: jsonDecoder) {
                    (response: AFDataResponse<ResponseDataType>) in
                    
                    print("Received response")
                    DispatchQueue.main.async {
                        switch response.result {
                        case .success(let value):
                            print("Resolving promise")
                            promise(.success(value))
                        case .failure(let error):
                            print(error)
//                            promise(.failure(error))
                        }
                    }
                }
        }
    }
}
