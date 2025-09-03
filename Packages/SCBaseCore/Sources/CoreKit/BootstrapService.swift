//
//  File.swift
//  SCBaseCore
//
//  Created by Marcelo Oscar José on 30/08/2025.
//

import Foundation

public protocol BootstrapService: Sendable {
    func ensureSeeded() async throws
}
