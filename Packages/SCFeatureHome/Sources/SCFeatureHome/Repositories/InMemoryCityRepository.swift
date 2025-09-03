//
//  InMemoryCityRepository.swift
//  SCFeatureHome
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation
import SCBaseCore

actor InMemoryCityRepository: CityRepository {
    private var all: [City]
    private var favorites: Set<Int> = []

    init(seed: [City]) {
        self.all = seed.sorted {
            if $0.name.lowercased() == $1.name.lowercased() {
                return $0.country.lowercased() < $1.country.lowercased()
            }
            return $0.name.lowercased() < $1.name.lowercased()
        }
    }

    func search(prefix: String, limit: Int) async throws -> [City] {
        if prefix.isEmpty { return Array(all.prefix(limit)) }
        let p = prefix.lowercased()
        return Array(all.lazy.filter { $0.name.lowercased().hasPrefix(p) }.prefix(limit))
    }

    func favorites() async throws -> Set<Int> {
        favorites
    }

    func setFavorite(_ id: Int, isFav: Bool) async throws {
        if isFav { favorites.insert(id) } else { favorites.remove(id) }
    }
}
