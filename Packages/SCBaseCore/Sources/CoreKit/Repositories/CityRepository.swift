//
//  CityRepository.swift
//  SCBaseCore
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation

public protocol CityRepository: Sendable {
    func search(prefix: String, limit: Int) async throws -> [City]
    func favorites() async throws -> Set<Int>
    func setFavorite(_ id: Int, isFav: Bool) async throws
}
