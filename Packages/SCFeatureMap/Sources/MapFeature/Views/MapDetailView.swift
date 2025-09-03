//
//  MapDetailView.swift
//  SCFeatureMap
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

import SwiftUI
import MapKit
import SCBaseCore

public struct MapDetailView: View {
    public let city: City
    @State private var position: MapCameraPosition

    public init(city: City) {
        self.city = city
        let center = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)
        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        let region = MKCoordinateRegion(center: center, span: span)
        self._position = State(initialValue: .region(region))
    }

    public var body: some View {
        Map(position: $position, interactionModes: .all) {
            let coordinate = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)
            Marker(city.name, coordinate: coordinate)
        }
    }
}
