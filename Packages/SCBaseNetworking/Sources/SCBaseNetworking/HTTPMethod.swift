//
//  HTTPMethod.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
