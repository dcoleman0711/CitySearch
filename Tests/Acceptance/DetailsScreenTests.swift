//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

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
}

class DetailsScreenSteps {

    func screenSizes() -> [CGSize] {

        [CGSize(width: 1024, height: 768), CGSize(width: 2048, height: 768), CGSize(width: 2048, height: 1536)]
    }

    func portraitOrientation() -> UIInterfaceOrientationMask {

        UIInterfaceOrientationMask.portrait
    }

    func detailsScreen() -> CityDetailsView {

        CityDetailsViewImp()
    }

    func detailsScreenIsLoaded(_ detailsScreen: CityDetailsView) {

        detailsScreen.loadViewIfNeeded()
    }

    func detailsScreenBackgroundIsWhite(_ detailsScreen: CityDetailsView) {

        XCTAssertEqual(detailsScreen.view.backgroundColor, UIColor.white, "Details screen background is not white")
    }
}