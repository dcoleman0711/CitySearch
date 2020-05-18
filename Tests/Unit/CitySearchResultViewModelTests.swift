//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class CitySearchResultModelTests: XCTestCase {

    var steps: CitySearchResultModelSteps!

    var given: CitySearchResultModelSteps { steps }
    var when: CitySearchResultModelSteps { steps }
    var then: CitySearchResultModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = CitySearchResultModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTitle() {

        let titleText = given.titleText()
        let model = given.model(titleText: titleText)

        let viewModel = when.viewModelIsCreated(model: model)

        then.viewModel(viewModel, textIs: titleText)
    }

    func testTapCommand() {

        let tapCommand = given.tapCommand()
        let model = given.model(tapCommand: tapCommand)

        let viewModel = when.viewModelIsCreated(model: model)

        then.viewModel(viewModel, tapCommandIs: tapCommand)
    }
}

class CitySearchResultModelSteps {

    func titleText() -> String {

        "Test Title"
    }

    func tapCommand() -> OpenDetailsCommandMock {

        OpenDetailsCommandMock()
    }

    func model(titleText: String = "", tapCommand: OpenDetailsCommandMock = OpenDetailsCommandMock()) -> CitySearchResultModelMock {

        let model = CitySearchResultModelMock()

        model.titleText = titleText
        model.tapCommand = tapCommand

        return model
    }

    func viewModelIsCreated(model: CitySearchResultModelMock) -> CitySearchResultViewModelImp {

        CitySearchResultViewModelFactoryImp().resultViewModel(model: model) as! CitySearchResultViewModelImp
    }

    func viewModel(_ viewModel: CitySearchResultViewModelImp, textIs expectedText: String) {

        XCTAssertEqual(viewModel.titleData.text, expectedText, "Title text is not correct")
    }

    func viewModel(_ viewModel: CitySearchResultViewModelImp, tapCommandIs expectedCommand: OpenDetailsCommandMock) {

        XCTAssertTrue(viewModel.tapCommand === expectedCommand, "Tap command is not correct")
    }
}