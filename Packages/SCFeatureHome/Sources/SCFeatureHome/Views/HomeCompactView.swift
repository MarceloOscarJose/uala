//
//  HomeCompactView.swift
//  SCFeatureHome
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

import SwiftUI
import SCFeatureCitySearch
import SCFeatureMap

public struct HomeCompactView: View {

    @StateObject private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.loadState {
            case .loading:
                ProgressView().navigationTitle("Cities")
            case .failed(let error):
                VStack(spacing: 12) {
                    Text("Error inicializando").font(.headline)
                    Text(error.localizedDescription).font(.footnote).foregroundStyle(.secondary)
                    Button("Reintentar") { viewModel.start() }
                }
                .padding()
                .navigationTitle("Cities")
            case .ready:
                if let searchVM = viewModel.searchViewModel {
                    CitySearchView(viewModel: searchVM, onSelect: { city in
                        viewModel.select(city)
                    })
                    .navigationDestination(item: Binding(
                        get: { viewModel.selectedCity },
                        set: { viewModel.selectedCity = $0 }
                    )) { city in
                        MapDetailView(city: city).navigationTitle(city.name)
                    }
                    .navigationTitle("Cities")
                    .accessibilityIdentifier(SCFeatureHomeIdentifier.navigationTitle.rawValue)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
