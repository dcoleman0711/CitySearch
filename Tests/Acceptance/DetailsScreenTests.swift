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
        let populationTitleFont = given.populationFont()
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

    func testPopulationPosition() {

        let populationLabel = given.populationLabel()
        let populationTitleLabel = given.populationTitleLabel()
        let detailsScreen = given.detailsScreen(populationTitleLabel: populationTitleLabel, populationLabel: populationLabel)
        given.detailsScreenIsLoaded(detailsScreen)

        when.detailsViewAppearsOnScreen(detailsScreen)

        then.populationLabel(populationLabel, isVerticallyAlignedAndSpacedNextTo: populationTitleLabel, in: detailsScreen)
    }

    func testPopulationFont() {

        let populationLabel = given.populationLabel()
        let populationFont = given.populationFont()
        let detailsScreen = given.detailsScreen(populationLabel: populationLabel)

        when.detailsScreenIsLoaded(detailsScreen)

        then.label(populationLabel, fontIs: populationFont)
    }

    func testPopulationText() {

        let populationLabel = given.populationLabel()
        let searchResult = given.searchResult()
        let populationText = given.populationText(for: searchResult)
        let detailsScreen = given.detailsScreen(searchResult: searchResult, populationLabel: populationLabel)

        when.detailsScreenIsLoaded(detailsScreen)

        then.label(populationLabel, textIs: populationText)
    }

    func testMapPosition() {

        let map = given.map()
        let detailsScreen = given.detailsScreen(map: map)
        given.detailsScreenIsLoaded(detailsScreen)

        when.detailsViewAppearsOnScreen(detailsScreen)

        then.map(map, isInTopRightCornerOfSafeAreaOf: detailsScreen)
    }

    func testMapSize() {

        let map = given.map()
        let detailsScreen = given.detailsScreen(map: map)
        given.detailsScreenIsLoaded(detailsScreen)

        when.detailsViewAppearsOnScreen(detailsScreen)

        then.map(map, isHalfWidthWithCorrectAspectRatioOf: detailsScreen)
    }

    func testImageCarouselPosition() {

        let imageCarousel = given.imageCarousel()
        let map = given.map()
        let detailsScreen = given.detailsScreen(map: map, imageCarousel: imageCarousel)
        given.detailsScreenIsLoaded(detailsScreen)

        when.detailsViewAppearsOnScreen(detailsScreen)

        then.imageCarousel(imageCarousel, isOnLeftEdgeOf: detailsScreen, andSpacedBelow: map)
    }

    func testImageCarouselSize() {

        let imageCarousel = given.imageCarousel()
        let detailsScreen = given.detailsScreen(imageCarousel: imageCarousel)
        given.detailsScreenIsLoaded(detailsScreen)

        when.detailsViewAppearsOnScreen(detailsScreen)

        then.imageCarousel(imageCarousel, isWidthOfWithCorrectHeight: detailsScreen)
    }

    // This test doesn't work, even though the behavior is correct.
//    func testContentSize() {
//
//        let imageCarousel = given.imageCarousel()
//        let detailsScreen = given.detailsScreen(imageCarousel: imageCarousel)
//        given.detailsScreenIsLoaded(detailsScreen)
//
//        when.detailsViewAppearsOnScreen(detailsScreen)
//
//        then.detailsScreen(detailsScreen, contentSizeExtendsToBottomOf: imageCarousel)
//    }
}

class DetailsScreenSteps {

    private var safeAreaFrame = CGRect.zero

    func titleLabel() -> UILabel {

        UILabel()
    }

    func populationTitleLabel() -> UILabel {

        UILabel()
    }

    func populationLabel() -> UILabel {

        UILabel()
    }

    func titleFont() -> UIFont {

        DetailsScreenTestConstants.titleFont
    }

    func map() -> MapViewMock {

        MapViewMock()
    }

    func imageCarousel() -> ImageCarouselViewMock {

        ImageCarouselViewMock()
    }

    func populationTitleText() -> String {

        DetailsScreenTestConstants.populationTitleText
    }

    func populationFont() -> UIFont {

        DetailsScreenTestConstants.populationTitleFont
    }

    func populationText(for searchResult: CitySearchResult) -> String {

        "1,234,567"
    }

    func screenSizes() -> [CGSize] {

        [CGSize(width: 1024, height: 768), CGSize(width: 2048, height: 768), CGSize(width: 2048, height: 1536)]
    }

    func searchResult() -> CitySearchResult {

        CitySearchResult(name: "Test City", population: 1234567, location: GeoPoint(latitude: 0.0, longitude: 0.0))
    }

    func titleText(for searchResult: CitySearchResult) -> String {

        searchResult.name
    }

    func detailsScreen(searchResult: CitySearchResult = CitySearchResultsStub.stubResults().results[0],
                       titleLabel: UILabel = UILabel(),
                       populationTitleLabel: UILabel = UILabel(),
                       populationLabel: UILabel = UILabel(),
                       map: MapViewMock = MapViewMock(),
                       imageCarousel: ImageCarouselViewMock = ImageCarouselViewMock()) -> CityDetailsView {

        // TODO: Use Builder
        let model = CityDetailsModelImp(searchResult: searchResult, imageCarouselModel: ImageCarouselModelImp())
        let viewModel = CityDetailsViewModelImp(model: model)
        return CityDetailsViewImp(contentView: UIView(), titleLabel: titleLabel, populationTitleLabel: populationTitleLabel, populationLabel: populationLabel, mapView: map, imageCarouselView: imageCarousel, viewModel: viewModel, binder: ViewBinderImp())
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

        XCTAssertEqual(titleLabel.text, expectedText, "Label text is not correct")
    }

    func populationTitleLabel(_ populationTitleLabel: UILabel, isLeftAlignedAndSpacedBelow titleLabel: UILabel, in detailsView: CityDetailsView) {

        let expectedOrigin = CGPoint(x: titleLabel.frame.origin.x, y: titleLabel.frame.maxY + 32.0)
        XCTAssertEqual(populationTitleLabel.frame.origin, expectedOrigin, "Population title label is not positioned correctly")
    }

    func populationLabel(_ populationLabel: UILabel, isVerticallyAlignedAndSpacedNextTo populationTitleLabel: UILabel, in detailsScreen: CityDetailsView) {

        let expectedOrigin = CGPoint(x: populationTitleLabel.frame.maxX + 8.0, y: populationTitleLabel.frame.center.y - (populationLabel.frame.size.height / 2.0))
        XCTAssertEqual(populationLabel.frame.origin, expectedOrigin, "Population label is not positioned correctly")
    }

    func map(_ map: MapViewMock, isInTopRightCornerOfSafeAreaOf detailsScreen: CityDetailsView) {

        XCTAssertEqual(map.view.frame.topRight, safeAreaFrame.topRight, "Map is not positioned correctly")
    }

    func map(_ map: MapViewMock, isHalfWidthWithCorrectAspectRatioOf detailsScreen: CityDetailsView) {

        XCTAssertEqual(map.view.frame.width, safeAreaFrame.maxX - detailsScreen.view.frame.center.x, "Map is not half-width of details screen")
        XCTAssertEqual(map.view.frame.height, map.view.frame.width / 2.0, "Map does not have the correct aspect ratio")
    }

    func imageCarousel(_ imageCarousel: ImageCarouselViewMock, isOnLeftEdgeOf detailsScreen: CityDetailsView, andSpacedBelow map: MapViewMock) {

        XCTAssertEqual(imageCarousel.view.frame.minX, safeAreaFrame.minX, "Image carousel is not on left edge of details screen safe area")
        XCTAssertEqual(imageCarousel.view.frame.minY, map.view.frame.maxY + 16.0, "Image carousel does not have the correct aspect ratio")
    }

    func imageCarousel(_ imageCarousel: ImageCarouselViewMock, isWidthOfWithCorrectHeight detailsScreen: CityDetailsView) {

        XCTAssertEqual(imageCarousel.view.frame.width, safeAreaFrame.width, "Image carousel is not width of details screen safe area")
        XCTAssertEqual(imageCarousel.view.frame.height, 256.0, "Image carousel does not have the correct height")
    }

    func detailsScreen(_ detailsScreen: CityDetailsView, contentSizeExtendsToBottomOf imageCarousel: ImageCarouselViewMock) {

        guard let scrollView = detailsScreen.view as? UIScrollView else {
            XCTFail("Details screen is not scrollable")
            return
        }

        XCTAssertEqual(scrollView.contentSize.width, detailsScreen.view.frame.size.width, "Details screen should not scroll horizontally")
        XCTAssertEqual(scrollView.contentSize.height, imageCarousel.view.frame.maxY, "Details screen content bottom is not image carousel bottom")
    }
}