//
//  Endpoint.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation

public protocol Endpoint: Sendable {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
    associatedtype Body: Encodable
    var body: Body? { get }
}

public extension Endpoint {
    var queryItems: [URLQueryItem] { [] }
    var headers: [String: String] { [:] }
    var body: EmptyBody? { nil }
}

public struct EmptyBody: Encodable, Sendable {
    public init() {}
}
