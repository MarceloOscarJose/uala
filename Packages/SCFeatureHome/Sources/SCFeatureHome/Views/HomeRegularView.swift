//
//  HomeRegularView.swift
//  SCFeatureHome
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

import SwiftUI
import SCFeatureCitySearch
import SCFeatureMap

public struct HomeRegularView: View {
    @StateObject private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        HStack(spacing: 0) {
            NavigationStack {
                switch viewModel.loadState {
                case .loading:
                    ProgressView()
                        .navigationTitle("Cities")

                case .failed(let error):
                    VStack(spacing: 12) {
                        Text("Error inicializando").font(.headline)
                        Text(error.localizedDescription).font(.footnote).foregroundStyle(.secondary)
                        Button("Reintentar") { viewModel.retry() }
                    }
                    .padding()
                    .navigationTitle("Cities")

                case .ready:
                    if let searchVM = viewModel.searchViewModel {
                        CitySearchView(
                            viewModel: searchVM,
                            onSelect: { city in
                                viewModel.select(city)
                            },
                            onSearch: {
                                let top = Array(searchVM.results)
                                viewModel.selectedCity = nil
                                viewModel.mapViewModel.preview(cities: top)
                            }
                        )
                        .navigationTitle("Cities")
                        .accessibilityIdentifier(SCFeatureHomeIdentifier.navigationTitle.rawValue)
                    }
                }
            }
            .frame(minWidth: 280, idealWidth: 340, maxWidth: 420)

            Divider()

            NavigationStack {
                MapPaneView(viewModel: viewModel.mapViewModel)
                    .navigationTitle(viewModel.selectedCity?.name ?? "Map")
            }
            .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear { viewModel.setPreviewEnabled(true) }
        .onDisappear { viewModel.setPreviewEnabled(false) }
    }
}
