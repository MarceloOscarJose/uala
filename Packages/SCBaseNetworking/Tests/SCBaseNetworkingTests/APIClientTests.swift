//
//  APIClientTests.swift
//  SCBaseNetworking
//
//  Created by Marcelo Oscar José on 03/09/2025.
//

import XCTest
@testable import SCBaseNetworking

final class APIClientTests: XCTestCase {
    private func makeSession(_ proto: URLProtocol.Type = URLProtocolStub.self) -> URLSession {
        let cfg = URLSessionConfiguration.ephemeral
        cfg.protocolClasses = [proto]
        return URLSession(configuration: cfg)
    }

    func test_success_decodes_json() async throws {
        let env = NetworkingEnvironment.test()
        let session = makeSession()
        let client = APIClient(environment: env, session: session)
        let dto = TestDTO(value: "ok")
        let data = try JSONEncoder().encode(dto)
        let url = URL(string: env.baseURL + "/test")!
        URLProtocolStub.register(.init(data: data, url: url, statusCode: 200, headers: ["Content-Type":"application/json"], error: nil))
        let result: TestDTO = try await client.send(TestEndpoint(), as: TestDTO.self)
        XCTAssertEqual(result, dto)
    }

    func test_http_error_is_mapped() async throws {
        let env = NetworkingEnvironment.test()
        let session = makeSession()
        let client = APIClient(environment: env, session: session)
        let url = URL(string: env.baseURL + "/test")!
        let body = Data("not found".utf8)
        URLProtocolStub.register(.init(data: body, url: url, statusCode: 404, headers: nil, error: nil))
        do {
            let _: TestDTO = try await client.send(TestEndpoint(), as: TestDTO.self)
            XCTFail("expected error")
        } catch let e as NetworkError {
            switch e {
            case .http(let code, let data):
                XCTAssertEqual(code, 404)
                XCTAssertEqual(data, body)
            default:
                XCTFail("unexpected error \(e)")
            }
        }
    }

    func test_invalid_response_error() async throws {
        final class URLProtocolNonHTTPStub: URLProtocol {
            override class func canInit(with request: URLRequest) -> Bool { true }
            override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
            override func startLoading() {
                let resp = URLResponse(url: request.url!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
                client?.urlProtocol(self, didReceive: resp, cacheStoragePolicy: .notAllowed)
                client?.urlProtocolDidFinishLoading(self)
            }
            override func stopLoading() {}
        }

        let env = NetworkingEnvironment.test()
        let session = makeSession(URLProtocolNonHTTPStub.self)
        let client = APIClient(environment: env, session: session)

        do {
            let _: TestDTO = try await client.send(TestEndpoint(), as: TestDTO.self)
            XCTFail("expected error")
        } catch let e as NetworkError {
            if case .invalidResponse = e {} else { XCTFail("unexpected \(e)") }
        }
    }
}
