//
//  Screen.swift
//  SmartCityExplorationUITests
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

import XCTest

protocol Screen {
    var app: XCUIApplication { get }
}

struct SmartCityUIMain: Screen {
    let app: XCUIApplication

    func setupArguments(args: [String]) {
        app.launchArguments = args
    }

    func launchApp() {
        app.launch()
    }
}
