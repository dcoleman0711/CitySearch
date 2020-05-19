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

    func testPopulationTitleLabelAutoResizeMaskDisabled() {

        let populationTitleLabel = given.populationTitleLabel()
        let detailsView = given.detailsView(populationTitleLabel: populationTitleLabel)

        when.detailsViewIsLoaded(detailsView)

        then.autoResizeMaskIsDisabled(populationTitleLabel)
    }

    func testPopulationTitleLabelPositionConstraints() {

        let populationTitleLabel = given.populationTitleLabel()
        let titleLabel = given.titleLabel()
        let detailsView = given.detailsView(titleLabel: titleLabel, populationTitleLabel: populationTitleLabel)
        let expectedConstraints = given.populationTitleLabel(populationTitleLabel, constraintsToLeftAlignAndSpaceBelow: titleLabel)

        when.detailsViewIsLoaded(detailsView)

        then.detailsView(detailsView, hasExpectedConstraints: expectedConstraints)
    }

    func testPopulationTitleLabelBindToViewModel() {

        let populationTitleLabel = given.populationTitleLabel()
        let viewModel = given.viewModel()
        let binder = given.binder()
        let detailsView = given.detailsView(populationTitleLabel: populationTitleLabel, viewModel: viewModel, binder: binder)

        when.detailsViewIsLoaded(detailsView)

        then.populationTitleLabel(populationTitleLabel, isBoundTo: viewModel)
    }

    func testPopulationLabelAutoResizeMaskDisabled() {

        let populationLabel = given.populationLabel()
        let detailsView = given.detailsView(populationLabel: populationLabel)

        when.detailsViewIsLoaded(detailsView)

        then.autoResizeMaskIsDisabled(populationLabel)
    }

    func testPopulationLabelPositionConstraints() {

        let populationLabel = given.populationLabel()
        let populationTitleLabel = given.populationTitleLabel()
        let detailsView = given.detailsView(populationTitleLabel: populationTitleLabel, populationLabel: populationLabel)
        let expectedConstraints = given.populationLabel(populationLabel, constraintsToRightAndVerticallyCenteredWith: populationTitleLabel)

        when.detailsViewIsLoaded(detailsView)

        then.detailsView(detailsView, hasExpectedConstraints: expectedConstraints)
    }

    func testPopulationLabelBindToViewModel() {

        let populationLabel = given.populationLabel()
        let viewModel = given.viewModel()
        let binder = given.binder()
        let detailsView = given.detailsView(populationLabel: populationLabel, viewModel: viewModel, binder: binder)

        when.detailsViewIsLoaded(detailsView)

        then.populationLabel(populationLabel, isBoundTo: viewModel)
    }

    func testMapViewAutoResizeMaskDisabled() {

        let mapView = given.mapView()
        let detailsView = given.detailsView(mapView: mapView)

        when.detailsViewIsLoaded(detailsView)

        then.autoResizeMaskIsDisabled(mapView.view)
    }

    func testMapViewPositionConstraints() {

        let mapView = given.mapView()
        let detailsView = given.detailsView(mapView: mapView)
        let expectedConstraints = given.mapView(mapView, constraintsToTopRightWithHalfWidthAnd2to1AspectRatio: detailsView)

        when.detailsViewIsLoaded(detailsView)

        then.detailsView(detailsView, hasExpectedConstraints: expectedConstraints)
    }

    func testImageCarouselViewAutoResizeMaskDisabled() {

        let imageCarouselView = given.imageCarouselView()
        let detailsView = given.detailsView(imageCarouselView: imageCarouselView)

        when.detailsViewIsLoaded(detailsView)

        then.autoResizeMaskIsDisabled(imageCarouselView.view)
    }

    func testImageCarouselViewPositionConstraints() {

        let imageCarouselView = given.imageCarouselView()
        let mapView = given.mapView()
        let detailsView = given.detailsView(mapView: mapView, imageCarouselView: imageCarouselView)
        let expectedConstraints = given.imageCarouselView(imageCarouselView, constraintsToSafeAreaEdgesOf: detailsView, andSpacedBelowWithCorrectHeight: mapView)

        when.detailsViewIsLoaded(detailsView)

        then.detailsView(detailsView, hasExpectedConstraints: expectedConstraints)
    }
}

class DetailsViewSteps {

    private var labelBoundToViewModel: UILabel?

    private var boundTitleLabel: UILabel?
    private var boundPopulationTitleLabel: UILabel?
    private var boundPopulationLabel: UILabel?

    func titleLabel() -> UILabel {

        UILabel()
    }

    func populationTitleLabel() -> UILabel {

        UILabel()
    }

    func populationLabel() -> UILabel {

        UILabel()
    }

    func mapView() -> MapViewMock {

        MapViewMock()
    }

    func imageCarouselView() -> ImageCarouselViewMock {

        ImageCarouselViewMock()
    }

    func viewModel() -> CityDetailsViewModelMock {

        let viewModel = CityDetailsViewModelMock()

        viewModel.observeTitleImp = { observer in

            observer(LabelViewModel.emptyData)
            self.boundTitleLabel = self.labelBoundToViewModel
        }

        viewModel.observePopulationTitleImp = { observer in

            observer(LabelViewModel.emptyData)
            self.boundPopulationTitleLabel = self.labelBoundToViewModel
        }

        viewModel.observePopulationImp = { observer in

            observer(LabelViewModel.emptyData)
            self.boundPopulationLabel = self.labelBoundToViewModel
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

    func detailsView(titleLabel: UILabel = UILabel(),
                     populationTitleLabel: UILabel = UILabel(),
                     populationLabel: UILabel = UILabel(),
                     mapView: MapViewMock = MapViewMock(), 
                     imageCarouselView: ImageCarouselViewMock = ImageCarouselViewMock(),
                     viewModel: CityDetailsViewModelMock = CityDetailsViewModelMock(),
                     binder: ViewBinderMock = ViewBinderMock()) -> CityDetailsViewImp {

        CityDetailsViewImp(titleLabel: titleLabel, populationTitleLabel: populationTitleLabel, populationLabel: populationLabel, mapView: mapView, imageCarouselView: imageCarouselView, viewModel: viewModel, binder: binder)
    }

    func detailsViewIsLoaded(_ detailsView: CityDetailsViewImp) {

        detailsView.loadViewIfNeeded()
    }

    func titleLabel(_ titleLabel: UILabel, constraintsToTopLeftSafeAreaOf detailsView: CityDetailsViewImp) -> [NSLayoutConstraint] {

        [titleLabel.leftAnchor.constraint(equalTo: detailsView.view.safeAreaLayoutGuide.leftAnchor),
         titleLabel.topAnchor.constraint(equalTo: detailsView.view.safeAreaLayoutGuide.topAnchor)]
    }

    func populationTitleLabel(_ populationTitleLabel: UILabel, constraintsToLeftAlignAndSpaceBelow titleLabel: UILabel) -> [NSLayoutConstraint] {

        [populationTitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
         populationTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.0)]
    }

    func populationLabel(_ populationLabel: UILabel, constraintsToRightAndVerticallyCenteredWith populationTitleLabel: UILabel) -> [NSLayoutConstraint] {

        [populationLabel.leftAnchor.constraint(equalTo: populationTitleLabel.rightAnchor, constant: 8.0),
         populationLabel.centerYAnchor.constraint(equalTo: populationTitleLabel.centerYAnchor)]
    }

    func mapView(_ mapView: MapViewMock, constraintsToTopRightWithHalfWidthAnd2to1AspectRatio detailsView: CityDetailsViewImp) -> [NSLayoutConstraint] {

        [mapView.view.rightAnchor.constraint(equalTo: detailsView.view.safeAreaLayoutGuide.rightAnchor),
         mapView.view.topAnchor.constraint(equalTo: detailsView.view.safeAreaLayoutGuide.topAnchor),
         mapView.view.leftAnchor.constraint(equalTo: detailsView.view.centerXAnchor),
         mapView.view.widthAnchor.constraint(equalTo: mapView.view.heightAnchor, multiplier: 2.0)]
    }

    func imageCarouselView(_ imageCarouselView: ImageCarouselViewMock, constraintsToSafeAreaEdgesOf detailsView: CityDetailsViewImp, andSpacedBelowWithCorrectHeight mapView: MapViewMock) -> [NSLayoutConstraint] {

        [imageCarouselView.view.leftAnchor.constraint(equalTo: detailsView.view.safeAreaLayoutGuide.leftAnchor),
         imageCarouselView.view.rightAnchor.constraint(equalTo: detailsView.view.safeAreaLayoutGuide.rightAnchor),
         imageCarouselView.view.topAnchor.constraint(equalTo: mapView.view.bottomAnchor, constant: 16.0),
         imageCarouselView.view.heightAnchor.constraint(equalToConstant: 256.0)]
    }

    func autoResizeMaskIsDisabled(_ view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresizing mask is not disabled")
    }

    func detailsView(_ detailsView: CityDetailsViewImp, hasExpectedConstraints expectedConstraints: [NSLayoutConstraint]) {

        ViewConstraintValidator.validateThatView(detailsView.view, hasConstraints: expectedConstraints, message: "Details view does not contain expected constraints")
    }

    func titleLabel(_ titleLabel: UILabel, isBoundTo viewModel: CityDetailsViewModelMock) {

        XCTAssertEqual(boundTitleLabel, titleLabel, "Title label is not bound to view model")
    }

    func populationTitleLabel(_ populationTitleLabel: UILabel, isBoundTo viewModel: CityDetailsViewModelMock) {

        XCTAssertEqual(boundPopulationTitleLabel, populationTitleLabel, "Population Title label is not bound to view model")
    }

    func populationLabel(_ populationLabel: UILabel, isBoundTo viewModel: CityDetailsViewModelMock) {

        XCTAssertEqual(boundPopulationLabel, populationLabel, "Population label is not bound to view model")
    }
}