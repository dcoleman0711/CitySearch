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

    func testTitleBindToViewModel() {

        let titleLabel = given.titleLabel()
        let viewModel = given.viewModel()
        let binder = given.binder()
        let detailsView = given.detailsView(titleLabel: titleLabel, viewModel: viewModel, binder: binder)

        when.detailsViewIsLoaded(detailsView)

        then.titleLabel(titleLabel, isBoundTo: viewModel)
    }
}

class DetailsViewSteps {

    private var labelBoundToViewModel: UILabel?

    func titleLabel() -> UILabel {

        UILabel()
    }

    func viewModel() -> CityDetailsViewModelMock {

        let viewModel = CityDetailsViewModelMock()

        viewModel.observeTitleImp = { observer in

            observer(LabelViewModel.emptyData)
        }

        return viewModel
    }

    func binder() -> ViewBinderMock {

        let binder = ViewBinderMock()

        binder.bindLabelTextImp = { (label) in

            { (text) in

                self.labelBoundToViewModel = label
            }
        }

        return binder
    }

    func detailsView(titleLabel: UILabel = UILabel(), viewModel: CityDetailsViewModelMock = CityDetailsViewModelMock(), binder: ViewBinderMock = ViewBinderMock()) -> CityDetailsViewImp {

        CityDetailsViewImp(titleLabel: titleLabel, viewModel: viewModel, binder: binder)
    }

    func detailsViewIsLoaded(_ detailsView: CityDetailsViewImp) {

        detailsView.loadViewIfNeeded()
    }

    func titleLabel(_ titleLabel: UILabel, constraintsToTopLeftSafeAreaOf detailsView: CityDetailsViewImp) -> [NSLayoutConstraint] {

        [titleLabel.leftAnchor.constraint(equalTo: detailsView.view.safeAreaLayoutGuide.leftAnchor),
         titleLabel.topAnchor.constraint(equalTo: detailsView.view.safeAreaLayoutGuide.topAnchor)]
    }

    func autoResizeMaskIsDisabled(_ view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresizing mask is not disabled")
    }

    func detailsView(_ detailsView: CityDetailsViewImp, hasExpectedConstraints expectedConstraints: [NSLayoutConstraint]) {

        ViewConstraintValidator.validateThatView(detailsView.view, hasConstraints: expectedConstraints, message: "Details view does not contain expected constraints")
    }

    func titleLabel(_ titleLabel: UILabel, isBoundTo viewModel: CityDetailsViewModelMock) {

        XCTAssertEqual(labelBoundToViewModel, titleLabel, "Title label is not bound to view model")
    }
}