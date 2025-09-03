//
//  CityRecord.swift
//  SCBasePersistence
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import GRDB
import SCBaseCore

public struct CityRecord: Codable, FetchableRecord, PersistableRecord, Sendable {
    public var id: Int
    public var name: String
    public var country: String
    public var lat: Double
    public var lon: Double
    public static let databaseTableName = "city"

    public static var persistenceConflictPolicy: PersistenceConflictPolicy {
        .init(insert: .replace, update: .replace)
    }
}

extension CityRecord {
    init(_ c: City) {
        self.id = c.id
        self.name = c.name
        self.country = c.country
        self.lat = c.lat
        self.lon = c.lon
    }
    var domain: City {
        City(id: id, name: name, country: country, lat: lat, lon: lon)
    }
}
