//
//  APIClient.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation

public struct EmptyDecodable: Decodable, Sendable { public init() {} }

public protocol NetworkClient: Sendable {
    func send<E: Endpoint, T: Decodable>(_ endpoint: E, as: T.Type) async throws -> T
}

struct APIClient: NetworkClient {
    private let environment: NetworkingEnvironment
    private let session: URLSession
    private let builder: RequestBuilder
    private let jsonDecoder: JSONDecoder

    public init(environment: NetworkingEnvironment, session: URLSession = .shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.environment = environment
        self.session = session
        self.builder = RequestBuilder(environment: environment)
        self.jsonDecoder = jsonDecoder
    }

    public func send<E: Endpoint, T: Decodable>(_ endpoint: E, as: T.Type) async throws -> T {
        let request = try builder.makeRequest(endpoint)
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
            guard (200..<300).contains(http.statusCode) else { throw NetworkError.http(code: http.statusCode, data: data) }
            if T.self == Data.self { return data as! T }
            if T.self == EmptyDecodable.self { return EmptyDecodable() as! T }
            if data.isEmpty { throw NetworkError.invalidResponse }
            do {
                return try jsonDecoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decoding(error)
            }
        } catch let e as URLError {
            throw NetworkError.transport(e)
        }
    }
}
