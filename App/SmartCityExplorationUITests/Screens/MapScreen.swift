//
//  MapScreen.swift
//  SmartCityExplorationUITests
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

import XCTest

struct MapScreen: Screen {
    let app: XCUIApplication
    
    func tapBack() -> HomeScreen {
        let back = app.navigationBars.buttons.element(boundBy: 0)
        back.tap()

        return HomeScreen(app: app)
    }
}
