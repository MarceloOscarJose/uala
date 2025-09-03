//
//  FeatureHomeCompactUITests.swift
//  SmartCityExplorationUITests
//
//  Created by Marcelo Oscar José on 02/09/2025.
//

import XCTest

final class FeatureHomeCompactUITests: XCTestCase {
    var app: XCUIApplication!
    var smartCityUIMain: SmartCityUIMain!

    override func setUpWithError() throws {
      continueAfterFailure = false
      app = XCUIApplication()
      smartCityUIMain = SmartCityUIMain(app: app)
      smartCityUIMain.setupArguments(args: ["UITEST_HOME_PREVIEW"])
      smartCityUIMain.launchApp()
        XCUIDevice.shared.orientation = .portrait
    }

    func testPreviewFocusAndReturnToPreview() {
        let _ = HomeScreen(app: app)
            .searchCityText("San")
            .tapResultCompact("San Francisco")
            .tapBack()
            .clearSearchText()
            .searchCityText("Ber")
            .tapResultCompact("Berlin")
            .tapBack()
    }
}
