//
//  HomeViewModel.swift
//  SCFeatureHome
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation
import Combine
import SCBaseCore
import SCFeatureCitySearch
import SCFeatureMap
import SCBaseNetworking
import SCBasePersistence

public enum HomeLoadState {
    case loading
    case ready
    case failed(Error)
}

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published public private(set) var loadState: HomeLoadState = .loading
    @Published public private(set) var searchViewModel: CitySearchViewModel?
    @Published public var selectedCity: City?

    public let mapViewModel = MapViewModel()
    private var started = false
    private var previewCancellable: AnyCancellable?

    public init() {
    }

    public func start() {
        guard !started else { return }
        started = true
        Task {
            do {
                let store = try CityStore()

                let api = try await Networking.shared.client()
                let loader: @Sendable () async throws -> [City] = {
                    let dtos: [CityDTO] = try await api.send(CitiesEndpoint(), as: [CityDTO].self)
                    return dtos.map(City.init(dto:))
                }
                let bootstrap = SQLiteBootstrapService(store: store, loader: loader)
                try await bootstrap.ensureSeeded()

                #if DEBUG
                let total = try await store.countCities()
                let integrity = try await store.integrityCheck()
                print("✅ Cities seeded:", total)
                print("🧪 integrity_check:", integrity)
                #endif

                let repo = SQLiteCityRepository(store: store)
                let searchVM = CitySearchViewModel(repo: repo)
                self.searchViewModel = searchVM
                self.loadState = .ready
            } catch {
                self.loadState = .failed(error)
            }
        }
    }

    public func retry() {
        started = false
        start()
    }

    public func select(_ city: City) {
        selectedCity = city
        mapViewModel.focus(on: city)
    }

    public func setPreviewEnabled(_ enabled: Bool, cap: Int = 50) {
        previewCancellable?.cancel()
        guard enabled, let searchVM = searchViewModel else {
            mapViewModel.clear()
            return
        }

        previewCancellable = searchVM.$results
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cities in
                self?.mapViewModel.preview(cities: Array(cities.prefix(cap)))
            }
    }

    func injectForPreview(searchVM: CitySearchViewModel) {
        self.searchViewModel = searchVM
        self.loadState = .ready
        self.setPreviewEnabled(true)
    }
}
