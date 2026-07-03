//
//  reward_jarUITestsLaunchTests.swift
//  reward-jarUITests
//
//  Created by Asad Saleem Qureshi on 6/17/26.
//
//  Description:
//  A launch test that opens the app and takes a screenshot of the first screen.
//  It's handy for confirming the app starts up correctly and for keeping a
//  visual record of the launch screen.
//

import XCTest

final class reward_jarUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app
        // XCUIAutomation Documentation
        // https://developer.apple.com/documentation/xcuiautomation

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
