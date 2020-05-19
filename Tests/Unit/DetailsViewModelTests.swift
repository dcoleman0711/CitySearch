//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class DetailsViewModelTests: XCTestCase {

    var steps: DetailsViewModelSteps!

    var given: DetailsViewModelSteps { steps }
    var when: DetailsViewModelSteps { steps }
    var then: DetailsViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = DetailsViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTitleFont() {

        let titleFont = given.titleFont()
        let detailsViewModel = given.detailsViewModel()
        let labelObserver = given.labelObserver()

        when.observer(labelObserver, observesTitleOn: detailsViewModel)

        then.observedFont(on: labelObserver, isEqualTo: titleFont)
    }
}

class DetailsViewModelSteps {

    private var observedLabelData: LabelViewModel?

    func titleFont() -> UIFont {

        DetailsScreenTestConstants.titleFont
    }

    func labelObserver() -> ValueUpdate<LabelViewModel> {

        { labelData in

            self.observedLabelData = labelData
        }
    }

    func detailsViewModel() -> CityDetailsViewModel {

        CityDetailsViewModelImp()
    }

    func observer(_ observer: @escaping ValueUpdate<LabelViewModel>, observesTitleOn viewModel: CityDetailsViewModel) {

        viewModel.observeTitle(observer)
    }

    func observedFont(on: ValueUpdate<LabelViewModel>, isEqualTo expectedFont: UIFont) {

        XCTAssertEqual(observedLabelData?.font, expectedFont, "Observed font is not correct font")
    }
}