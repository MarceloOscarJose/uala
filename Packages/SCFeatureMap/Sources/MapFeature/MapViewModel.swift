//
//  MapViewModel.swift
//  SCFeatureMap
//
//  Created by Marcelo Oscar José on 01/09/2025.
//

import Foundation
import MapKit
import SCBaseCore

@MainActor
public final class MapViewModel: ObservableObject {

    @Published public private(set) var region: MKCoordinateRegion?
    @Published public var annotations: [MapAnnotationModel] = []

    public init() {}

    public func focus(on city: City, span: MKCoordinateSpan = .init(latitudeDelta: 2, longitudeDelta: 2)) {
        region = MKCoordinateRegion(center: .init(latitude: city.lat, longitude: city.lon), span: span)
        annotations = [MapAnnotationModel(id: city.id, title: city.name, lat: city.lat, lon: city.lon)]
    }

    public func preview(cities: [City], cap: Int = 50) {
        let slice = cities.prefix(cap)
        let anns = slice.map { MapAnnotationModel(id: $0.id, title: $0.name, lat: $0.lat, lon: $0.lon) }

        let newRegion: MKCoordinateRegion? = slice.first.map {
            .init(center: .init(latitude: $0.lat, longitude: $0.lon),
                  span: .init(latitudeDelta: 20, longitudeDelta: 20))
        }

        if let r = newRegion { region = r }
        self.annotations = anns
    }

    public func clear() {
        annotations = []
        let span = MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 60)
        region = .init(center: .init(latitude: 0, longitude: 0), span: span)
    }
}
