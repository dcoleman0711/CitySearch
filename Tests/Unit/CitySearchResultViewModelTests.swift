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
        let model = given.model(titleText)

        let viewModel = when.viewModelIsCreated(model: model)

        then.viewModel(viewModel, textIs: titleText)
    }
}

class CitySearchResultModelSteps {

    func titleText() -> String {

        "Test Title"
    }

    func model(_ titleText: String) -> CitySearchResultModelMock {

        let model = CitySearchResultModelMock()

        model.titleText = titleText

        return model
    }

    func viewModelIsCreated(model: CitySearchResultModelMock) -> CitySearchResultViewModelImp {

        CitySearchResultViewModelFactoryImp().resultViewModel(model: model) as! CitySearchResultViewModelImp
    }

    func viewModel(_ viewModel: CitySearchResultViewModelImp, textIs expectedText: String) {

        XCTAssertEqual(viewModel.titleText, expectedText, "Title text is not correct")
    }
}