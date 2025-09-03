//
//  HomeViewModel+Preview.swift
//  SCFeatureHome
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

#if DEBUG
import Foundation
import SCBaseCore
import SCFeatureCitySearch

extension HomeViewModel {
    public static func preview(file: String = "preview-cities") -> HomeViewModel {
        let seed = loadPreviewCities(named: file)
        let repo = InMemoryCityRepository(seed: seed)
        let searchVM = CitySearchViewModel(repo: repo)
        let vm = HomeViewModel()
        vm.injectForPreview(searchVM: searchVM)
        return vm
    }

    private static func loadPreviewCities(named file: String) -> [City] {
        guard
            let url = Bundle.module.url(forResource: file, withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else { return [] }

        if let cities = try? JSONDecoder().decode([City].self, from: data) {
            return cities
        }

        let dtos = (try? JSONDecoder().decode([CityDTO].self, from: data)) ?? []
        return dtos.map { City(dto: $0) }
    }
}
#endif
