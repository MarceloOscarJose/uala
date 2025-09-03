//
//  City+Mapping.swift
//  SCBaseCore
//
//  Created by Marcelo Oscar José on 31/08/2025.
//

import Foundation

public extension City {
    init(dto: CityDTO) {
        self.init(
            id: dto._id,
            name: dto.name,
            country: dto.country,
            lat: dto.coord.lat,
            lon: dto.coord.lon
        )
    }
}
