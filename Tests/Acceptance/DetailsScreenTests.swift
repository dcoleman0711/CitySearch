//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class DetailsScreenTestConstants {

    static let titleFont = UIFont.systemFont(ofSize: 36.0)
    static let populationTitleFont = UIFont.systemFont(ofSize: 24.0)
    static let populationTitleText = "Population: "
}

class DetailsScreenTests: XCTestCase {

    var steps: DetailsScreenSteps!

    var given: DetailsScreenSteps { steps }
    var when: DetailsScreenSteps { steps }
    var then: DetailsScreenSteps { steps }

    override func setUp() {

        super.setUp()

        steps = DetailsScreenSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testBackgroundIsWhite() {

        let detailsScreen = given.detailsScreen()

        when.detailsScreenIsLoaded(detailsScreen)

        then.detailsScreenBackgroundIsWhite(detailsScreen)
    }

    func testTitlePosition() {

        let titleLabel = given.titleLabel()
        let detailsScreen = given.detailsScreen(titleLabel: titleLabel)
        given.detailsScreenIsLoaded(detailsScreen)

        when.detailsViewAppearsOnScreen(detailsScreen)

        then.titleLabel(titleLabel, isInTopLeftCornerOfSafeAreaOf: detailsScreen)
    }

    func testTitleFont() {

        let titleLabel = given.titleLabel()
        let titleFont = given.titleFont()
        let detailsScreen = given.detailsScreen(titleLabel: titleLabel)

        when.detailsScreenIsLoaded(detailsScreen)

        then.label(titleLabel, fontIs: titleFont)
    }

    func testTitleText() {

        let titleLabel = given.titleLabel()
        let searchResult = given.searchResult()
        let titleText = given.titleText(for: searchResult)
        let detailsScreen = given.detailsScreen(searchResult: searchResult, titleLabel: titleLabel)

        when.detailsScreenIsLoaded(detailsScreen)

        then.label(titleLabel, textIs: titleText)
    }

    func testPopulationTitlePosition() {

        let populationTitleLabel = given.populationTitleLabel()
        let titleLabel = given.titleLabel()
        let detailsScreen = given.detailsScreen(titleLabel: titleLabel, populationTitleLabel: populationTitleLabel)
        given.detailsScreenIsLoaded(detailsScreen)

        when.detailsViewAppearsOnScreen(detailsScreen)

        then.populationTitleLabel(populationTitleLabel, isLeftAlignedAndSpacedBelow: titleLabel, in: detailsScreen)
    }

    func testPopulationTitleFont() {

        let populationTitleLabel = given.populationTitleLabel()
        let populationTitleFont = given.populationTitleFont()
        let detailsScreen = given.detailsScreen(populationTitleLabel: populationTitleLabel)

        when.detailsScreenIsLoaded(detailsScreen)

        then.label(populationTitleLabel, fontIs: populationTitleFont)
    }

    func testPopulationTitleText() {

        let populationTitleLabel = given.populationTitleLabel()
        let populationTitleText = given.populationTitleText()
        let detailsScreen = given.detailsScreen(populationTitleLabel: populationTitleLabel)

        when.detailsScreenIsLoaded(detailsScreen)

        then.label(populationTitleLabel, textIs: populationTitleText)
    }
}

class DetailsScreenSteps {

    private var safeAreaFrame = CGRect.zero

    func titleLabel() -> UILabel {

        UILabel()
    }

    func populationTitleLabel() -> UILabel {

        UILabel()
    }

    func titleFont() -> UIFont {

        DetailsScreenTestConstants.titleFont
    }

    func populationTitleText() -> String {

        DetailsScreenTestConstants.populationTitleText
    }

    func populationTitleFont() -> UIFont {

        DetailsScreenTestConstants.populationTitleFont
    }

    func screenSizes() -> [CGSize] {

        [CGSize(width: 1024, height: 768), CGSize(width: 2048, height: 768), CGSize(width: 2048, height: 1536)]
    }

    func searchResult() -> CitySearchResult {

        CitySearchResult(name: "Test City")
    }

    func titleText(for searchResult: CitySearchResult) -> String {

        searchResult.name
    }

    func detailsScreen(searchResult: CitySearchResult = CitySearchResult(name: ""), titleLabel: UILabel = UILabel(), populationTitleLabel: UILabel = UILabel()) -> CityDetailsView {

        CityDetailsViewImp(titleLabel: titleLabel, populationTitleLabel: populationTitleLabel, viewModel: CityDetailsViewModelImp(model: CityDetailsModelImp(searchResult: searchResult)), binder: ViewBinderImp())
    }

    func detailsScreenIsLoaded(_ detailsScreen: CityDetailsView) {

        detailsScreen.loadViewIfNeeded()
    }

    func detailsViewAppearsOnScreen(_ detailsScreen: CityDetailsView) {

        SafeAreaLayoutTest.layoutInWindow(detailsScreen, andCaptureSafeAreaTo: &self.safeAreaFrame)
    }

    func detailsScreenBackgroundIsWhite(_ detailsScreen: CityDetailsView) {

        XCTAssertEqual(detailsScreen.view.backgroundColor, UIColor.white, "Details screen background is not white")
    }

    func titleLabel(_ titleLabel: UILabel, isInTopLeftCornerOfSafeAreaOf: CityDetailsView) {

        XCTAssertEqual(titleLabel.frame.origin, safeAreaFrame.origin, "Title label is not in top-left corner of safe area")
    }

    func label(_ titleLabel: UILabel, fontIs expectedFont: UIFont) {

        XCTAssertEqual(titleLabel.font, expectedFont, "Title label font is not expected font")
    }

    func label(_ titleLabel: UILabel, textIs expectedText: String) {

        XCTAssertEqual(titleLabel.text, expectedText, "Title label text is not correct")
    }

    func populationTitleLabel(_ populationTitleLabel: UILabel, isLeftAlignedAndSpacedBelow titleLabel: UILabel, in detailsView: CityDetailsView) {

        let expectedOrigin = CGPoint(x: titleLabel.frame.origin.x, y: titleLabel.frame.maxY + 32.0)
        XCTAssertEqual(populationTitleLabel.frame.origin, expectedOrigin, "Population title label is not positioned correctly")
    }
}
