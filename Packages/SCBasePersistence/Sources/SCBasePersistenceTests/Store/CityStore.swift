//
//  CityStore.swift
//  SCBasePersistence
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import Foundation
import GRDB
import SCBaseCore

public actor CityStore {
    private let dbQueue: DatabaseQueue
    public let dbPath: String
    private static let defaultDBName: String = "cities.sqlite"

    public init(path: String? = nil) throws {
        self.dbPath = try path ?? Self.getDefaultDataBasePath()
        dbQueue = try DatabaseQueue(path: dbPath)

        print("📂 Database path: \(self.dbPath)")
        try Self.migrator.migrate(dbQueue)
    }

    private static func getDefaultDataBasePath() throws -> String {
        let support = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        return support.appendingPathComponent(defaultDBName).path
    }

    private static var migrator: DatabaseMigrator {
        var m = DatabaseMigrator()

        m.registerMigration("v1_schema") { db in
            try db.create(table: "city") { t in
                t.primaryKey("id", .integer)
                t.column("name", .text).notNull()
                t.column("country", .text).notNull()
                t.column("lat", .double).notNull()
                t.column("lon", .double).notNull()
            }
            try db.create(table: "favorite") { t in
                t.primaryKey("cityId", .integer)
                t.foreignKey(["cityId"], references: "city", onDelete: .cascade)
            }
            try db.create(index: "idx_city_name_country", on: "city", columns: ["name", "country"])
        }

        m.registerMigration("v2_city_fts5") { db in
            try db.create(virtualTable: "city_fts", using: FTS5()) { t in
                t.column("name")
                t.content = "city"
                t.contentRowID = "id"
                t.tokenizer = .unicode61(
                    diacritics: .removeLegacy,
                    categories: "",
                    separators: [],
                    tokenCharacters: []
                )
            }
            try db.execute(sql: "INSERT INTO city_fts(city_fts) VALUES ('rebuild')")
            try db.execute(sql: "INSERT INTO city_fts(city_fts) VALUES ('optimize')")
        }

        return m
    }
}

extension CityStore {
    public func isEmpty() throws -> Bool {
        try dbQueue.read { db in
            (try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM city") ?? 0) == 0
        }
    }

    public func countCities() throws -> Int {
        try dbQueue.read { db in
            try Int.fetchOne(db, sql: "SELECT COUNT(*) FROM city") ?? 0
        }
    }

    public func integrityCheck() throws -> String {
        try dbQueue.read { db in
            try String.fetchOne(db, sql: "PRAGMA integrity_check")
        } ?? "unknown"
    }

    public func importCities(_ cities: [City], batchSize: Int = 5000) throws {
        try dbQueue.write { db in
            var i = 0
            while i < cities.count {
                let slice = cities[i ..< min(i + batchSize, cities.count)]
                for city in slice {
                    try CityRecord(city).insert(db)
                }
                i += batchSize
            }
            try db.execute(sql: "INSERT INTO city_fts(city_fts) VALUES ('rebuild')")
            try db.execute(sql: "INSERT INTO city_fts(city_fts) VALUES ('optimize')")
        }
    }
    
    public func search(prefix: String, limit: Int) throws -> [City] {
        if prefix.isEmpty {
            return []
        } else {
            let q = prefix.lowercased() + "*"
            return try dbQueue.read { db in
                try CityRecord
                    .fetchAll(db, sql: """
                        SELECT c.id, c.name, c.country, c.lat, c.lon
                        FROM city c
                        JOIN city_fts f ON f.rowid = c.id
                        WHERE f.name MATCH ?
                        ORDER BY c.name COLLATE NOCASE ASC, c.country COLLATE NOCASE ASC
                        LIMIT ?
                    """, arguments: [q, limit])
                    .map { $0.domain }
            }
        }
    }

    public func getFavorites() throws -> Set<Int> {
        try dbQueue.read { db in
            Set(try Int.fetchAll(db, sql: "SELECT cityId FROM favorite"))
        }
    }

    public func setFavorite(id: Int, isFav: Bool) throws {
        try dbQueue.write { db in
            if isFav {
                try db.execute(
                    sql: "INSERT OR IGNORE INTO favorite(cityId) VALUES (?)",
                    arguments: [id]
                )
            } else {
                try db.execute(
                    sql: "DELETE FROM favorite WHERE cityId = ?",
                    arguments: [id]
                )
            }
        }
    }
}
