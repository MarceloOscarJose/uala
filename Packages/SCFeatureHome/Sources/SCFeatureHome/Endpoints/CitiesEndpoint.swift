//
//  CitiesEndpoint.swift
//  SCBasePersistence
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import SCBaseNetworking

struct CitiesEndpoint: Endpoint {
    var method: HTTPMethod = .get
    let path: String = "/dce8843a8edbe0b0018b32e137bc2b3a/raw/cities.json"
    typealias Body = EmptyBody
}
