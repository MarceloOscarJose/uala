//
//  SQLiteCityRepository.swift
//  SCBasePersistence
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import Foundation
import SCBaseCore

public final class SQLiteCityRepository: CityRepository, @unchecked Sendable {
    private let store: CityStore

    public init(store: CityStore) {
        self.store = store
    }

    public func search(prefix: String, limit: Int) async throws -> [City] {
        try await store.search(prefix: prefix, limit: limit)
    }

    public func favorites() async throws -> Set<Int> {
        try await store.getFavorites()
    }

    public func setFavorite(_ id: Int, isFav: Bool) async throws {
        try await store.setFavorite(id: id, isFav: isFav)
    }
}
