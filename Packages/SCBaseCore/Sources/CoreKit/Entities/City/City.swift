//
//  City.swift
//  SCBaseCore
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation

public struct City: Codable, Hashable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let country: String
    public let lat: Double
    public let lon: Double

    public init(id: Int, name: String, country: String, lat: Double, lon: Double) {
        self.id = id
        self.name = name
        self.country = country
        self.lat = lat
        self.lon = lon
    }
}
