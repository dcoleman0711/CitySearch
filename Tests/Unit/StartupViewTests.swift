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

        when.startupViewIsLoaded(startupView)

        then.startupViewBackgroundIsWhite(startupView)
    }

    func testAppTitleLabelIsOnStartupView() {

        let appTitleLabel = given.appTitleLabel()
        let startupView = given.startupView(appTitleLabel: appTitleLabel)

        when.startupViewIsLoaded(startupView)

        then.appTitleLabel(appTitleLabel, isOnStartupView: startupView)
    }

    func testAppTitleLabelAutoResizeMaskDisabled() {

        let appTitleLabel = given.appTitleLabel()
        let startupView = given.startupView(appTitleLabel: appTitleLabel)

        when.startupViewIsLoaded(startupView)

        then.autoResizeMaskIsDisabled(appTitleLabel)
    }

    func testAppTitleLabelCenter() {

        let appTitleLabel = given.appTitleLabel()
        let startupView = given.startupView(appTitleLabel: appTitleLabel)
        let expectedConstraints = given.constraintsForCenter(appTitleLabel, equalTo: startupView)

        when.startupViewIsLoaded(startupView)

        then.startupView(startupView, hasConstraints: expectedConstraints)
    }

    func testAppTitleLabelFont() {

        let appTitleLabel = given.appTitleLabel()
        let startupView = given.startupView(appTitleLabel: appTitleLabel)
        let expectedFont = given.appTitleFont(appTitleLabel)

        when.startupViewIsLoaded(startupView)

        then.appTitleLabel(appTitleLabel, fontIs: expectedFont)
    }

    func testAppTitleLabelIsBoundToModel() {

        let appTitleLabel = given.appTitleLabel()
        let startupModel = given.startupModel()
        let binder = given.binder()
        let startupView = given.startupView(appTitleLabel: appTitleLabel, startupModel: startupModel, binder: binder)

        when.startupViewIsLoaded(startupView)
        
        then.appTitleLabel(appTitleLabel, isBoundToModel: startupModel)
    }
}

class StartupViewSteps {

    private var labelBoundToModel: UILabel?
    private var textUpdatePassedToModel: ValueUpdate<String>?

    func appTitleFont(_ label: UILabel) -> UIFont {

        StartupTestConstants.appTitleFont
    }

    func binder() -> ViewBinderMock {

        let binder = ViewBinderMock()

        binder.bindLabelTextImp = { (label) in

            { (text) in

                self.labelBoundToModel = label
            }
        }

        return binder
    }

    func startupModel() -> StartupModelMock {

        let startupModel = StartupModelMock()

        startupModel.observeAppTitleTextImp = { (textUpdate) in

            textUpdate("")
        }

        return startupModel
    }

    func constraintsForCenter(_ appTitleLabel: UILabel, equalTo startupView: StartupViewImp) -> [NSLayoutConstraint] {

        [appTitleLabel.centerXAnchor.constraint(equalTo: startupView.view.centerXAnchor),
         appTitleLabel.centerYAnchor.constraint(equalTo: startupView.view.centerYAnchor)]
    }

    func startupView(appTitleLabel: UILabel = UILabel(), startupModel: StartupModelMock = StartupModelMock(), binder: ViewBinderMock = ViewBinderMock()) -> StartupViewImp {

        StartupViewImp(appTitleLabel: appTitleLabel, model: startupModel, binder: binder)
    }

    func appTitleLabel() -> UILabel {

        UILabel()
    }

    func startupViewIsLoaded(_ startupView: StartupViewImp) {

        startupView.loadViewIfNeeded()
    }

    func startupViewBackgroundIsWhite(_ startupView: StartupViewImp) {

        XCTAssertEqual(startupView.view.backgroundColor, UIColor.white)
    }

    func appTitleLabel(_ appTitleLabel: UILabel, isOnStartupView startupView: StartupViewImp) {

        XCTAssertTrue(startupView.view.subviews.contains(appTitleLabel), "Startup view does not contain app title label")
    }

    func autoResizeMaskIsDisabled(_ view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresizing mask is not disabled")
    }

    func startupView(_ startupView: StartupViewImp, hasConstraints expectedConstraints: [NSLayoutConstraint]) {

        XCTAssertTrue(startupView.view.constraints.contains { constraint in expectedConstraints.contains { expectedConstraint in constraint.isEqualToConstraint(expectedConstraint) } }, "Startup view does not contain expected constraints")
    }

    func appTitleLabel(_ appTitleLabel: UILabel, isBoundToModel model: StartupModelMock) {

        XCTAssertEqual(labelBoundToModel, appTitleLabel, "App title text is not bound to model")
    }

    func appTitleLabel(_ appTitleLabel: UILabel, fontIs font: UIFont) {

        XCTAssertEqual(appTitleLabel.font, font, "App title font is not correct")
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
