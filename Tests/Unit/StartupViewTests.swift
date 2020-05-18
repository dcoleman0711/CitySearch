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

    func testAppTitleLabelIsBoundToViewModel() {

        let appTitleLabel = given.appTitleLabel()
        let startupViewModel = given.startupViewModel()
        let binder = given.binder()
        let startupView = given.startupView(appTitleLabel: appTitleLabel, startupViewModel: startupViewModel, binder: binder)

        when.startupViewIsLoaded(startupView)

        then.appTitleLabel(appTitleLabel, isBoundToViewModel: startupViewModel)
    }

    func testTransitionIsScheduled() {

        let startupModel = given.startupModel()
        let startupView = given.startupView(startupModel: startupModel)

        when.startupViewIsLoaded(startupView)

        then.transitionIsScheduled(startupModel)
    }
}

class StartupViewSteps {

    private var labelBoundToModel: UILabel?
    private var textUpdatePassedToViewModel: ValueUpdate<LabelViewModel>?

    private var transitionScheduled = false

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

        startupModel.startTransitionTimerImp = {

            self.transitionScheduled = true
        }

        return startupModel
    }

    func startupViewModel() -> StartupViewModelMock {

        let startupViewModel = StartupViewModelMock()

        startupViewModel.observeAppTitleImp = { (viewModelUpdate) in

            viewModelUpdate(LabelViewModel.emptyData)
        }

        return startupViewModel
    }

    func constraintsForCenter(_ appTitleLabel: UILabel, equalTo startupView: StartupViewImp) -> [NSLayoutConstraint] {

        [appTitleLabel.centerXAnchor.constraint(equalTo: startupView.view.centerXAnchor),
         appTitleLabel.centerYAnchor.constraint(equalTo: startupView.view.centerYAnchor)]
    }

    func startupView(appTitleLabel: UILabel = UILabel(), startupModel: StartupModelMock = StartupModelMock(), startupViewModel: StartupViewModelMock = StartupViewModelMock(), binder: ViewBinderMock = ViewBinderMock()) -> StartupViewImp {

        startupViewModel.model = startupModel

        return StartupViewImp(appTitleLabel: appTitleLabel, viewModel: startupViewModel, binder: binder)
    }

    func appTitleLabel() -> UILabel {

        UILabel()
    }

    func startupViewIsLoaded(_ startupView: StartupViewImp) {

        startupView.loadViewIfNeeded()
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

    func appTitleLabel(_ appTitleLabel: UILabel, isBoundToViewModel model: StartupViewModelMock) {

        XCTAssertEqual(labelBoundToModel, appTitleLabel, "App title text is not bound to model")
    }

    func transitionIsScheduled(_ startupModel: StartupModelMock) {

        XCTAssertTrue(transitionScheduled, "Transition was not scheduled")
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
