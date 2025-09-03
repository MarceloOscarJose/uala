//
//  CitySearchViewModel.swift
//  SCFeatureCitySearch
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation
import SCBaseCore

@MainActor
public final class CitySearchViewModel: ObservableObject {
    private let repository: CityRepository
    @Published public private(set) var results: [City] = []
    @Published public var favorites: Set<Int> = []

    private var lastQuery: String = ""
    private var searchTask: Task<Void, Never>?

    public init(repo: CityRepository) {
        self.repository = repo
        Task { [weak self] in
            guard let self else { return }
            let favs = (try? await self.repository.favorites()) ?? []
            await MainActor.run { self.favorites = favs }
        }
    }

    public func search(_ query: String) {
        lastQuery = query
        searchTask?.cancel()

        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            results = []
            return
        }

        let current = query
        searchTask = Task.detached { [weak self] in
            guard let self else { return }
            let list = (try? await self.repository.search(prefix: current, limit: 50)) ?? []
            guard !Task.isCancelled else { return }
            await MainActor.run {
                if current == self.lastQuery { self.results = list }
            }
        }
    }

    public func toggleFavorite(_ id: Int) {
        let newValue = !favorites.contains(id)
        Task { [weak self] in
            guard let self else { return }
            try? await self.repository.setFavorite(id, isFav: newValue)
            await MainActor.run {
                if newValue { self.favorites.insert(id) } else { self.favorites.remove(id) }
            }
        }
    }
}
