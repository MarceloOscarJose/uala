//
//  RequestBuilder.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import Foundation

struct RequestBuilder: Sendable {
    private let environment: NetworkingEnvironment
    private let jsonEncoder: JSONEncoder

    public init(environment: NetworkingEnvironment, jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.environment = environment
        self.jsonEncoder = jsonEncoder
    }

    public func makeRequest<E: Endpoint>(_ endpoint: E) throws -> URLRequest {
        guard let baseURL = URL(string: environment.baseURL) else {
            throw NetworkError.invalidURL
        }

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = joinedPath(base: baseURL.path, endpoint: endpoint.path)
        if !endpoint.queryItems.isEmpty { components?.queryItems = endpoint.queryItems }
        guard let url = components?.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url, cachePolicy: environment.cachePolicy, timeoutInterval: environment.timeout)
        request.httpMethod = endpoint.method.rawValue

        environment.defaultHeaders.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        if let body = endpoint.body {
            request.httpBody = try jsonEncoder.encode(body)
        }

        return request
    }

    private func joinedPath(base: String, endpoint: String) -> String {
        let baseTrim = base.hasSuffix("/") ? String(base.dropLast()) : base
        let endTrim  = endpoint.hasPrefix("/") ? String(endpoint.dropFirst()) : endpoint
        let joined = baseTrim + "/" + endTrim
        return joined.hasPrefix("/") ? joined : "/" + joined
    }
}
