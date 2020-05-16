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

    func testAppTitleLabelAutoResizeMaskDisabled() {

        let startupView = given.startupView()
        let appTitleLabel = given.appTitleLabel(startupView)

        then.autoResizeMaskIsDisabled(appTitleLabel)
    }

    func testAppTitleLabelWidth() {

        let startupView = given.startupView()
        let appTitleLabel = given.appTitleLabel(startupView)
        let expectedConstraint = given.constraintForWidth(appTitleLabel, isHalfOfWidth: startupView)

        then.startupView(startupView, hasConstraints: [expectedConstraint])
    }
}

class StartupViewSteps {

    func constraintForWidth(_ appTitleLabel: UILabel, isHalfOfWidth startupView: StartupView) -> NSLayoutConstraint {

        NSLayoutConstraint(item: appTitleLabel, attribute: .width, relatedBy: .equal, toItem: startupView.view, attribute: .width, multiplier: 0.5, constant: 0.0)
    }

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

        XCTAssertTrue(startupView.view.subviews.contains(appTitleLabel), "Startup view does not contain app title label")
    }

    func autoResizeMaskIsDisabled(_ view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresizing mask is not disabled")
    }

    func startupView(_ startupView: StartupView, hasConstraints expectedConstraints: [NSLayoutConstraint]) {

        XCTAssertTrue(startupView.view.constraints.contains { constraint in expectedConstraints.contains { expectedConstraint in constraint.isEqualToConstraint(expectedConstraint) } }, "Startup view does not contain expected constraints")
    }
}

extension NSLayoutConstraint {

    func isEqualToConstraint(_ other: NSLayoutConstraint) -> Bool {

        self.firstItem === other.firstItem &&
                self.firstAttribute == other.firstAttribute &&
                self.relation == other.relation &&
                self.secondItem === other.secondItem &&
                self.secondAttribute == other.secondAttribute &&
                self.multiplier == other.multiplier &&
                self.constant == other.constant &&
                self.priority == other.priority
    }
}