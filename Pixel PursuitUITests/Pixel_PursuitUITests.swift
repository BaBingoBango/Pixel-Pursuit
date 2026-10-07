//
//  Pixel_PursuitUITests.swift
//  Pixel PursuitUITests
//
//  Created by Ethan Marshall on 4/18/23.
//

import XCTest

final class Pixel_PursuitUITests: XCTestCase {
    override func setUpWithError() throws {
        // Stop at the first failure: later steps depend on earlier ones.
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchShowsThePowerSwitch() throws {
        // The game is designed for landscape, so that's how the launch test plays it.
        XCUIDevice.shared.orientation = .landscapeLeft

        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.buttons["Main power on"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
