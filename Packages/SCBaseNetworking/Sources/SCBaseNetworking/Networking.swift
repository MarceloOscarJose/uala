//
//  Networking.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import Foundation

public enum NetworkingError: Error { case notConfigured }

public actor Networking {
    public static let shared = Networking()
    private var _client: NetworkClient?

    private init() {}

    public func configure(environment: NetworkingEnvironment) {
        _client = APIClient(environment: environment)
    }

    public func use(_ client: NetworkClient) {
        _client = client
    }

    public func client() throws -> NetworkClient {
        guard let client = _client else { throw NetworkingError.notConfigured }
        return client
    }
}
