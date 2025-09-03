//
//  File.swift
//  SCFeatureHome
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

import Foundation

public enum SCFeatureHomeIdentifier {
    case navigationTitle

    public var rawValue: String {
        switch self {
            case .navigationTitle:
              return "HOME_NAVIGATION_TITLE"
        }
    }
}
