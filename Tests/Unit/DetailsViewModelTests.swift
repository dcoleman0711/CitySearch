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
        let model = given.model()
        let detailsViewModel = given.detailsViewModel(model: model)
        let labelObserver = given.labelObserver()

        when.observer(labelObserver, observesTitleOn: detailsViewModel)

        then.observedFont(on: labelObserver, isEqualTo: titleFont)
    }

    func testTitleText() {

        let model = given.model()
        let titleText = given.titleText(from: model)
        let detailsViewModel = given.detailsViewModel(model: model)
        let labelObserver = given.labelObserver()

        when.observer(labelObserver, observesTitleOn: detailsViewModel)

        then.observedText(on: labelObserver, isEqualTo: titleText)
    }

    func testPopulationTitleFont() {

        let populationFont = given.populationFont()
        let model = given.model()
        let detailsViewModel = given.detailsViewModel(model: model)
        let labelObserver = given.labelObserver()

        when.observer(labelObserver, observesPopulationTitleOn: detailsViewModel)

        then.observedFont(on: labelObserver, isEqualTo: populationFont)
    }

    func testPopulationTitleText() {

        let populationTitle = given.populationTitleText()
        let model = given.model()
        let detailsViewModel = given.detailsViewModel(model: model)
        let labelObserver = given.labelObserver()

        when.observer(labelObserver, observesPopulationTitleOn: detailsViewModel)

        then.observedText(on: labelObserver, isEqualTo: populationTitle)
    }

    func testPopulationFont() {

        let populationFont = given.populationFont()
        let model = given.model()
        let detailsViewModel = given.detailsViewModel(model: model)
        let labelObserver = given.labelObserver()

        when.observer(labelObserver, observesPopulationOn: detailsViewModel)

        then.observedFont(on: labelObserver, isEqualTo: populationFont)
    }

    func testPopulationText() {

        let model = given.model()
        let populationText = given.populationText(from: model)
        let detailsViewModel = given.detailsViewModel(model: model)
        let labelObserver = given.labelObserver()

        when.observer(labelObserver, observesPopulationOn: detailsViewModel)

        then.observedText(on: labelObserver, isEqualTo: populationText)
    }
}

class DetailsViewModelSteps {

    private let titleText = "Test Title"
    private let population = 1234567

    private var observedLabelData: LabelViewModel?

    private var modelTitleObserver: ValueUpdate<String>?

    func titleFont() -> UIFont {

        DetailsScreenTestConstants.titleFont
    }

    func populationFont() -> UIFont {

        DetailsScreenTestConstants.populationTitleFont
    }

    func populationTitleText() -> String {

        DetailsScreenTestConstants.populationTitleText
    }

    func labelObserver() -> ValueUpdate<LabelViewModel> {

        { labelData in

            self.observedLabelData = labelData
        }
    }

    func model() -> CityDetailsModelMock {

        let model = CityDetailsModelMock()

        model.observeTitleTextImp = { observer in

            observer(self.titleText)
        }

        model.observePopulationImp = { observer in

            observer(self.population)
        }

        return model
    }

    func titleText(from model: CityDetailsModelMock) -> String {

        titleText
    }

    func populationText(from: CityDetailsModelMock) -> String {

        "1,234,567"
    }

    func detailsViewModel(model: CityDetailsModelMock) -> CityDetailsViewModel {

        CityDetailsViewModelImp(model: model)
    }

    func observer(_ observer: @escaping ValueUpdate<LabelViewModel>, observesTitleOn viewModel: CityDetailsViewModel) {

        viewModel.observeTitle(observer)
    }

    func observer(_ observer: @escaping ValueUpdate<LabelViewModel>, observesPopulationTitleOn viewModel: CityDetailsViewModel) {

        viewModel.observePopulationTitle(observer)
    }

    func observer(_ observer: @escaping ValueUpdate<LabelViewModel>, observesPopulationOn viewModel: CityDetailsViewModel) {

        viewModel.observePopulation(observer)
    }

    func observedFont(on: ValueUpdate<LabelViewModel>, isEqualTo expectedFont: UIFont) {

        XCTAssertEqual(observedLabelData?.font, expectedFont, "Observed font is not correct font")
    }

    func observedText(on: ValueUpdate<LabelViewModel>, isEqualTo expectedText: String) {

        XCTAssertEqual(observedLabelData?.text, expectedText, "Observed text is not correct text")
    }
}
