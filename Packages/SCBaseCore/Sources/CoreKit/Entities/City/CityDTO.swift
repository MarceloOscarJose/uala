//
//  CityDTO.swift
//  SCBaseCore
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation

public struct CityDTO: Codable {
    public let country: String
    public let name: String
    public let _id: Int
    public let coord: Coord
    public struct Coord: Codable, Sendable {
        public let lon: Double
        public let lat: Double
    }
}
