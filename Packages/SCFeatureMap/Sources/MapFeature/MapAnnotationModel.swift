//
//  MapAnnotationModel.swift
//  SCFeatureMap
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

import Foundation
import CoreLocation

public struct MapAnnotationModel: Identifiable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let lat: Double
    public let lon: Double

    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    public init(id: Int, title: String, lat: Double, lon: Double) {
        self.id = id
        self.title = title
        self.lat = lat
        self.lon = lon
    }

    public static func == (lhs: MapAnnotationModel, rhs: MapAnnotationModel) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
