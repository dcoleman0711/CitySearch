//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class StartupViewTests: XCTestCase {

    var steps: StartupViewSteps!

    var given: StartupViewSteps { steps }
    var when: StartupViewSteps { steps }
    var then: StartupViewSteps { steps }

    override func setUp() {

        super.setUp()

        steps = StartupViewSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testBackgroundColorIsWhite() {

        let startupView = given.startupView()

        then.startupViewBackgroundIsWhite(startupView)
    }

    func testAppTitleLabelIsOnStartupView() {

        let startupView = given.startupView()
        let appTitleLabel = given.appTitleLabel(startupView)

        then.appTitleLabel(appTitleLabel, isOnStartupView: startupView)
    }
}

class StartupViewSteps {

    func startupView() -> StartupView {

        StartupView()
    }

    func appTitleLabel(_ startupView: StartupView) -> UILabel {

        startupView.appTitleLabel
    }

    func startupViewBackgroundIsWhite(_ startupView: StartupView) {

        XCTAssertEqual(startupView.view.backgroundColor, UIColor.white)
    }

    func appTitleLabel(_ appTitleLabel: UILabel, isOnStartupView startupView: StartupView) {

        XCTAssertTrue(startupView.view.subviews.contains(appTitleLabel))
    }
}