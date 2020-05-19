//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class DetailsViewTests: XCTestCase {

    var steps: DetailsViewSteps!

    var given: DetailsViewSteps { steps }
    var when: DetailsViewSteps { steps }
    var then: DetailsViewSteps { steps }

    override func setUp() {

        super.setUp()

        steps = DetailsViewSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTitleLabelAutoResizeMaskDisabled() {

        let titleLabel = given.titleLabel()
        let detailsView = given.detailsView(titleLabel: titleLabel)

        when.detailsViewIsLoaded(detailsView)

        then.autoResizeMaskIsDisabled(titleLabel)
    }

    func testTitlePositionConstraints() {

        let titleLabel = given.titleLabel()
        let detailsView = given.detailsView(titleLabel: titleLabel)
        let expectedConstraints = given.titleLabel(titleLabel, constraintsToTopLeftSafeAreaOf: detailsView)

        when.detailsViewIsLoaded(detailsView)

        then.detailsView(detailsView, hasExpectedConstraints: expectedConstraints)
    }
}

class DetailsViewSteps {

    func titleLabel() -> UILabel {

        UILabel()
    }

    func detailsView(titleLabel: UILabel = UILabel()) -> CityDetailsView {

        CityDetailsViewImp(titleLabel: titleLabel)
    }

    func detailsViewIsLoaded(_ detailsView: CityDetailsView) {

        detailsView.loadViewIfNeeded()
    }

    func titleLabel(_ titleLabel: UILabel, constraintsToTopLeftSafeAreaOf detailsView: CityDetailsView) -> [NSLayoutConstraint] {

        [titleLabel.leftAnchor.constraint(equalTo: detailsView.view.safeAreaLayoutGuide.leftAnchor),
         titleLabel.topAnchor.constraint(equalTo: detailsView.view.safeAreaLayoutGuide.topAnchor)]
    }

    func detailsViewBackgroundIsWhite(_ detailsView: CityDetailsView) {

        XCTAssertEqual(detailsView.view.backgroundColor, UIColor.white, "Details screen background is not white")
    }

    func autoResizeMaskIsDisabled(_ view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresizing mask is not disabled")
    }

    func detailsView(_ detailsView: CityDetailsView, hasExpectedConstraints expectedConstraints: [NSLayoutConstraint]) {

        ViewConstraintValidator.validateThatView(detailsView.view, hasConstraints: expectedConstraints, message: "Details view does not contain expected constraints")
    }
}