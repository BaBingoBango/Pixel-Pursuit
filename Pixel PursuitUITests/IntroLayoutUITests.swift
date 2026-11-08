//
//  IntroLayoutUITests.swift
//  Pixel PursuitUITests
//
//  Created by Ethan Marshall on 11/8/26.
//

import XCTest

/// The intro screens use fixed type sizes, so these tests check that they still fit the screen in both
/// orientations. App Review found the System Access Warning clipped on an 11-inch iPad; run this on the
/// smallest iPad too.
final class IntroLayoutUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testWarningScreenFitsInPortrait() throws {
        try checkWarningScreen(in: .portrait)
    }

    @MainActor
    func testWarningScreenFitsInLandscape() throws {
        try checkWarningScreen(in: .landscapeLeft)
    }

    @MainActor
    private func checkWarningScreen(in orientation: UIDeviceOrientation) throws {
        XCUIDevice.shared.orientation = orientation
        let app = XCUIApplication()
        app.launch()

        let power = app.buttons["Main power on"]
        XCTAssertTrue(power.waitForExistence(timeout: 5))
        sleep(4) // the title fades in
        attachScreenshot(of: app, named: "Title")
        power.tap()

        let title = app.staticTexts["SYSTEM ACCESS WARNING"]
        XCTAssertTrue(title.waitForExistence(timeout: 15), "The warning screen never appeared.")
        sleep(4) // the warning fades in
        attachScreenshot(of: app, named: "Warning")

        let paragraph = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "This is a system")).firstMatch
        let activate = app.buttons["ACTIVATE SYSTEM"]
        for element in [title, paragraph, activate] {
            XCTAssertTrue(element.exists, "\(element) is missing")
            XCTAssertTrue(app.frame.contains(element.frame), "\(element.label) runs off the screen: \(element.frame) is not inside \(app.frame)")
        }
        XCTAssertTrue(activate.isHittable)
    }

    private func attachScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
