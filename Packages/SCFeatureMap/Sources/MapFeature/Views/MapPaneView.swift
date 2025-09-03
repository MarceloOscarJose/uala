//
//  MapPaneView.swift
//  SCFeatureMap
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

import SwiftUI
import MapKit

public struct MapPaneView: View {
    @ObservedObject private var viewModel: MapViewModel
    @State private var region: MKCoordinateRegion =
            .init(center: .init(latitude: 0, longitude: 0),
                  span: .init(latitudeDelta: 60, longitudeDelta: 60))

    public init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: .all,
            annotationItems: viewModel.annotations
        ) { item in
            MapMarker(coordinate: item.coordinate)
        }
        .onReceive(viewModel.$region.compactMap { $0 }) { r in
            region = r
        }
    }
}
