//
//  HomeScreen.swift
//  SmartCityExplorationUITests
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

import SCFeatureHome
import XCTest

struct HomeScreen: Screen {
    let app: XCUIApplication
    
    private enum Identifiers {
        static let homeTitle = SCFeatureHomeIdentifier.navigationTitle.rawValue
    }

    func searchCityText(_ text: String) -> HomeScreen {
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 2))
        search.tap()
        search.typeText(text)
        return HomeScreen(app: app)
    }

    func clearSearchText() -> HomeScreen {
        let search = app.searchFields.firstMatch
        search.tap()
        let currentValue = search.value as? String ?? ""
        if !currentValue.isEmpty {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentValue.count)
            search.typeText(deleteString)
        }
        
        return HomeScreen(app: app)
    }

    func tapResultRegular(_ text: String) -> HomeScreen {
        let cell = app.cells.staticTexts[text].firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 2))
        cell.tap()
        
        return HomeScreen(app: app)
    }

    func tapResultCompact(_ text: String) -> MapScreen {
        let cell = app.cells.staticTexts[text].firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 2))
        cell.tap()
        
        return MapScreen(app: app)
    }
}
