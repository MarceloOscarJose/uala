//
//  CitySearchView.swift
//  SCFeatureCitySearch
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import SwiftUI
import SCBaseCore

public struct CitySearchView: View {
    @ObservedObject var viewModel: CitySearchViewModel
    @State private var query: String = ""

    public var onSelect: ((City) -> Void)?
    public var onSearch: (() -> Void)?

    public init(viewModel: CitySearchViewModel, onSelect: ((City) -> Void)? = nil, onSearch: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelect = onSelect
        self.onSearch = onSearch
    }

    public var body: some View {
        List(viewModel.results, id: \.id) { city in
            HStack {
                VStack(alignment: .leading) {
                    Text(city.name)
                    Text(city.country).font(.footnote).foregroundStyle(.secondary)
                }
                Spacer()
                Button(viewModel.favorites.contains(city.id) ? "★" : "☆") {
                    viewModel.toggleFavorite(city.id)
                }
                .buttonStyle(.borderless)
            }
            .contentShape(Rectangle())
            .onTapGesture { onSelect?(city) }
        }
        .listStyle(.plain)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: query) {
            viewModel.search($0)
            onSearch?()
        }
        .scrollDismissesKeyboard(.immediately)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
