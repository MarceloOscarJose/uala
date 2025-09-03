//
//  SQLiteBootstrapService.swift
//  SCBasePersistence
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import Foundation
import SCBaseCore

public final class SQLiteBootstrapService: BootstrapService, @unchecked Sendable {
    private let store: CityStore
    private let loader: @Sendable () async throws -> [City]

    public init(store: CityStore, loader: @escaping @Sendable () async throws -> [City]) {
        self.store = store
        self.loader = loader
    }

    public func ensureSeeded() async throws {
        let isEmpty = try await store.isEmpty()
        guard isEmpty else { return }
        let cities = try await loader()
        try await store.importCities(cities)
    }
}
