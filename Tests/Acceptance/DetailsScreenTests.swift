//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class DetailsScreenTestConstants {

    static let titleFont = UIFont.systemFont(ofSize: 36.0)
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

        then.titleLabel(titleLabel, fontIs: titleFont)
    }
}

class DetailsScreenSteps {

    private var safeAreaFrame = CGRect.zero

    func titleLabel() -> UILabel {

        UILabel()
    }

    func titleFont() -> UIFont {

        DetailsScreenTestConstants.titleFont
    }

    func screenSizes() -> [CGSize] {

        [CGSize(width: 1024, height: 768), CGSize(width: 2048, height: 768), CGSize(width: 2048, height: 1536)]
    }

    func detailsScreen(titleLabel: UILabel = UILabel()) -> CityDetailsView {

        CityDetailsViewImp(titleLabel: titleLabel, viewModel: CityDetailsViewModelImp(), binder: ViewBinderImp())
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

    func titleLabel(_ titleLabel: UILabel, fontIs expectedFont: UIFont) {

        XCTAssertEqual(titleLabel.font, expectedFont, "Title label font is not expected font")
    }
}