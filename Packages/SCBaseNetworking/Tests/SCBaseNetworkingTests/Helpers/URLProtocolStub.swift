//
//  URLProtocolStub.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 03/09/2025.
//

import Foundation

final class URLProtocolStub: URLProtocol {
    struct Stub: Sendable {
        let data: Data?
        let url: URL
        let statusCode: Int
        let headers: [String:String]?
        let error: URLError?
    }

    final class Storage: @unchecked Sendable {
        static let shared = Storage()
        private let queue = DispatchQueue(label: "URLProtocolStub.Storage")
        private var stub: Stub?
        func set(_ s: Stub?) { queue.sync { stub = s } }
        func get() -> Stub? { queue.sync { stub } }
    }

    static func register(_ stub: Stub) { Storage.shared.set(stub) }
    static func remove() { Storage.shared.set(nil) }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let stub = Storage.shared.get() else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }

        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        let response = HTTPURLResponse(
            url: stub.url,
            statusCode: stub.statusCode,
            httpVersion: nil,
            headerFields: stub.headers
        )!

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
