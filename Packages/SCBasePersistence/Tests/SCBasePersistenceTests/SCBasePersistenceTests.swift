//
//  SCBasePersistenceTests.swift
//  SCBasePersistenceTests
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import Testing
import XCTest
@testable import SCBasePersistence
@testable import SCBaseCore

final class CityStoreTests: XCTestCase {

    // MARK: - Helpers
    private func makeTempDBPath(_ function: StaticString = #function) -> String {
        let base = NSTemporaryDirectory()
        let name = "test-\(UUID().uuidString).sqlite"
        return (base as NSString).appendingPathComponent(name)
    }

    private func seedCities() -> [City] {
        return [
            City(id: 1, name: "Barcelona", country: "ES", lat: 41.3874, lon: 2.1686),
            City(id: 2, name: "Berlin",    country: "DE", lat: 52.5200, lon: 13.4050),
            City(id: 3, name: "Boston",    country: "US", lat: 42.3601, lon: -71.0589),
            City(id: 4, name: "Cordoba",   country: "AR", lat: -31.4201, lon: -64.1888),
            City(id: 5, name: "Cordoba",   country: "ES", lat: 37.8882,  lon: -4.7794),
            City(id: 6, name: "san jose",  country: "CR", lat: 9.9281,   lon: -84.0907),
            City(id: 7, name: "San Juan",  country: "AR", lat: -31.5375, lon: -68.5364),
        ]
    }

    // MARK: - Tests

    func test_migrations_and_integrity_ok() async throws {
        let path = makeTempDBPath()
        let store = try CityStore(path: path)

        let integrity = try await store.integrityCheck()
        XCTAssertEqual(integrity.lowercased(), "ok")

        let isEmpty = try await store.isEmpty()
        XCTAssertTrue(isEmpty)
    }

    func test_import_and_count() async throws {
        let path = makeTempDBPath()
        let store = try CityStore(path: path)

        try await store.importCities(seedCities())
        let count = try await store.countCities()
        XCTAssertEqual(count, 7)
    }

    func test_search_prefix_case_insensitive_and_sorting() async throws {
        let path = makeTempDBPath()
        let store = try CityStore(path: path)

        try await store.importCities(seedCities())

        let co = try await store.search(prefix: "co", limit: 10)
        XCTAssert(co.first?.name == "Cordoba")
        XCTAssert(co.first?.country == "AR")
        
        XCTAssert(co.last?.name == "Cordoba")
        XCTAssert(co.last?.country == "ES")

        // case-insensitive
        let sanUpper = try await store.search(prefix: "SAN", limit: 10)
        let sanLower = try await store.search(prefix: "san", limit: 10)
        XCTAssertEqual(sanUpper.map(\.id), sanLower.map(\.id))

        let san = try await store.search(prefix: "san", limit: 10)

        XCTAssert(san.first?.name == "san jose")
        XCTAssert(san.first?.country == "CR")

        XCTAssert(san.last?.name == "San Juan")
        XCTAssert(san.last?.country == "AR")
    }

    func test_search_empty_prefix_returns_empty_list() async throws {
        let path = makeTempDBPath()
        let store = try CityStore(path: path)
        try await store.importCities(seedCities())

        let empty = try await store.search(prefix: "", limit: 50)
        XCTAssertTrue(empty.isEmpty)
    }

    func test_favorites_persistence() async throws {
        let path = makeTempDBPath()
        let store = try CityStore(path: path)
        try await store.importCities(seedCities())

        var favs = try await store.getFavorites()
        XCTAssertTrue(favs.isEmpty)

        try await store.setFavorite(id: 2, isFav: true)  // Berlin
        try await store.setFavorite(id: 5, isFav: true)  // Cordoba ES

        favs = try await store.getFavorites()
        XCTAssertEqual(favs, Set([2, 5]))

        try await store.setFavorite(id: 2, isFav: false)
        favs = try await store.getFavorites()
        XCTAssertEqual(favs, Set([5]))
    }

    func test_integrity_after_import_and_fts_rebuild() async throws {
        let path = makeTempDBPath()
        let store = try CityStore(path: path)
        try await store.importCities(seedCities())

        let integrity = try await store.integrityCheck()
        XCTAssertEqual(integrity.lowercased(), "ok")
    }

    func test_search_performance_small_seed() throws {
        let path = makeTempDBPath()
        let store = try CityStore(path: path)

        var many: [City] = []
        for i in 0..<100000 {
            let o = i * 100
            many += seedCities().map { c in
                City(id: c.id + o, name: c.name, country: c.country, lat: c.lat, lon: c.lon)
            }
        }

        let seedExp = expectation(description: "seed")
        Task {
            try? await store.importCities(many)
            seedExp.fulfill()
        }
        wait(for: [seedExp], timeout: 30)

        measure {
            let exp = expectation(description: "search")
            Task {
                _ = try? await store.search(prefix: "san", limit: 50)
                exp.fulfill()
            }
            wait(for: [exp], timeout: 5)
        }
    }
}
