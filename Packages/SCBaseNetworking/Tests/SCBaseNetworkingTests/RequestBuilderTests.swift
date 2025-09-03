//
//  RequestBuilderTests.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 03/09/2025.
//

import XCTest
@testable import SCBaseNetworking

final class RequestBuilderTests: XCTestCase {
    func test_builds_request_path_query_headers_body() throws {
        let env = NetworkingEnvironment.test(base: "https://api.example.com/base")
        let builder = RequestBuilder(environment: env)

        struct B: Encodable, Sendable { let a: Int }

        let ep = EPWithBody(
            method: .post,
            path: "/cities",
            queryItems: [URLQueryItem(name: "q", value: "ba")],
            headers: ["X-F1": "A", "Content-Type": "application/json"],
            body: B(a: 1)
        )

        let req = try builder.makeRequest(ep)
        XCTAssertEqual(req.url?.absoluteString, "https://api.example.com/base/cities?q=ba")
        XCTAssertEqual(req.httpMethod, "POST")
        XCTAssertEqual(req.value(forHTTPHeaderField: "X-Env"), "T")
        XCTAssertEqual(req.value(forHTTPHeaderField: "X-F1"), "A")
        XCTAssertEqual(req.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(req.cachePolicy, env.cachePolicy)
        XCTAssertEqual(req.timeoutInterval, env.timeout)
        XCTAssertNotNil(req.httpBody)
    }

    func test_get_request_no_body_no_content_type() throws {
        let env = NetworkingEnvironment.test(base: "https://ex.com")
        let builder = RequestBuilder(environment: env)
        let req = try builder.makeRequest(TestEndpoint(method: .get, path: "/ping"))
        XCTAssertNil(req.httpBody)
        XCTAssertNil(req.value(forHTTPHeaderField: "Content-Type"))
    }
}

struct EPWithBody<B: Encodable & Sendable>: Endpoint, Sendable {
    typealias Body = B
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]
    var body: B?

    init(method: HTTPMethod,
         path: String,
         queryItems: [URLQueryItem] = [],
         headers: [String: String] = [:],
         body: B) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }
}
