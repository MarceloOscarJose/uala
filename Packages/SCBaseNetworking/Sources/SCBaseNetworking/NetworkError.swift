//
//  NetworkError.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation

public enum NetworkError: Error, Sendable {
    case invalidURL
    case transport(URLError)
    case invalidResponse
    case http(code: Int, data: Data)
    case decoding(Error)
}
