//
//  NetworkingFixtures.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 03/09/2025.
//

import Foundation
@testable import SCBaseNetworking

struct TestDTO: Codable, Equatable { let value: String }

struct TestEndpoint: Endpoint {
    typealias Body = EmptyBody
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem] = []
    var headers: [String:String] = [:]
    var body: Body? = nil
    init(method: HTTPMethod = .get, path: String = "/test", queryItems: [URLQueryItem] = [], headers: [String:String] = [:]) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
    }
}

extension NetworkingEnvironment {
    static func test(base: String = "https://example.com") -> NetworkingEnvironment {
        NetworkingEnvironment(baseURL: base, defaultHeaders: ["X-Env": "T"], timeout: 15, cachePolicy: .reloadIgnoringLocalCacheData)
    }
}
