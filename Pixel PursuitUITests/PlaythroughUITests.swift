//
//  PlaythroughUITests.swift
//  Pixel PursuitUITests
//
//  Created by Ethan Marshall on 4/18/23.
//

import XCTest

/// Plays the game as far as the simulator allows. The proximity triggers in Amanda's disk need a real room,
/// so the playthrough ends once Agent W has sent the player off to explore the disk.
final class PlaythroughUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testPlayThroughToAmandasDisk() throws {
        // Portrait on purpose: on a rotated simulator, XCUITest's synthesized taps miss controls away from the
        // screen's center, and the HUD buttons live in the corners.
        XCUIDevice.shared.orientation = .portrait
        let app = XCUIApplication()
        app.launch()

        let powerButton = app.buttons["Main power on"]
        XCTAssertTrue(powerButton.waitForExistence(timeout: 5))
        tapOnceVisible(powerButton)

        // Initializing and bootup play out on their own, about three seconds each.
        let activateButton = app.buttons["ACTIVATE SYSTEM"]
        XCTAssertTrue(activateButton.waitForExistence(timeout: 20))
        tapOnceVisible(activateButton)

        // The disk table scene loads and the mission interface comes online.
        let advanceButton = app.buttons["tap to advance text"]
        XCTAssertTrue(advanceButton.waitForExistence(timeout: 30))

        // Agent W's briefing takes five taps before the office opens up.
        for _ in 0..<5 {
            advanceButton.tap()
        }
        let searchOfficeButton = app.buttons["search amanda's office"]
        XCTAssertTrue(searchOfficeButton.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Good luck, Agent! The IDDA thanks you!"].exists)
        searchOfficeButton.tap()

        // In the office, the only way forward is Amanda's password.
        let decryptButton = app.buttons["decrypt disk"]
        XCTAssertTrue(decryptButton.waitForExistence(timeout: 10))
        decryptButton.tap()

        let passwordField = app.textFields["Disk password"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        passwordField.typeText("mike4neva")
        app.buttons["SUBMIT"].tap()

        // Unlocked: Agent W has one more line before sending the player into the disk.
        XCTAssertTrue(advanceButton.waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Excellent work! Now we can dive into Amanda's hard drive."].exists)
        advanceButton.tap()
        let searchDiskButton = app.buttons["search amanda's disk"]
        XCTAssertTrue(searchDiskButton.waitForExistence(timeout: 5))
        searchDiskButton.tap()

        // Inside the disk, Agent W says their piece and then the player has to walk the room.
        XCTAssertTrue(advanceButton.waitForExistence(timeout: 10))
        advanceButton.tap()
        advanceButton.tap()
        XCTAssertTrue(app.staticTexts["If you can find anything on that, we'll be golden!"].waitForExistence(timeout: 5))
    }

    /// The title and warning screens fade in over several seconds, and a tap on a nearly transparent view
    /// goes nowhere, so give a freshly appeared button a moment before tapping it.
    @MainActor
    private func tapOnceVisible(_ button: XCUIElement) {
        sleep(1)
        button.tap()
    }
}
