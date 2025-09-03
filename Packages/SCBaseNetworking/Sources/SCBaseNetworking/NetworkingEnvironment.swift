//
//  NetworkingEnvironment.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import Foundation

public struct NetworkingEnvironment: Sendable {
    public let baseURL: String
    public let defaultHeaders: [String: String]
    public let timeout: TimeInterval
    public let cachePolicy: URLRequest.CachePolicy

    public init(
        baseURL: String,
        defaultHeaders: [String: String] = [:],
        timeout: TimeInterval = 30,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeout = timeout
        self.cachePolicy = cachePolicy
    }
}
