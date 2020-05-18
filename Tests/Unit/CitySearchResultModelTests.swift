//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class CitySearchResultViewModelTests: XCTestCase {

    var steps: CitySearchResultViewModelSteps!

    var given: CitySearchResultViewModelSteps { steps }
    var when: CitySearchResultViewModelSteps { steps }
    var then: CitySearchResultViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = CitySearchResultViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTitle() {

        let searchResult = given.searchResult()

        let model = when.modelIsCreated(searchResult: searchResult)

        then.model(model, titleIs: searchResult.name)
    }

    func testTapCommand() {

        let searchResult = given.searchResult()
        let tapCommandFactory = given.tapCommandFactory()
        let tapCommand = given.tapCommand(createdBy: tapCommandFactory, for: searchResult)

        let model = when.modelIsCreated(searchResult: searchResult, tapCommandFactory: tapCommandFactory)

        then.model(model, tapCommandIs: tapCommand)
    }
}

class CitySearchResultViewModelSteps {

    func searchResult() -> CitySearchResult {

        CitySearchResult(name: "Test City")
    }

    func tapCommandFactory() -> OpenDetailsCommandFactoryMock {

        OpenDetailsCommandFactoryMock()
    }

    func tapCommand(createdBy factory: OpenDetailsCommandFactoryMock, for searchResult: CitySearchResult) -> OpenDetailsCommandMock {

        let command = OpenDetailsCommandMock()

        factory.openDetailsCommandImp = { result in

            if result == searchResult { return command }

            return OpenDetailsCommandMock()
        }

        return command
    }

    func modelIsCreated(searchResult: CitySearchResult, tapCommandFactory: OpenDetailsCommandFactoryMock = OpenDetailsCommandFactoryMock()) -> CitySearchResultModelImp {

        CitySearchResultModelFactoryImp().resultModel(searchResult: searchResult, tapCommandFactory: tapCommandFactory) as! CitySearchResultModelImp
    }

    func model(_ model: CitySearchResultModelImp, titleIs expectedTitle: String) {

        XCTAssertEqual(model.titleText, expectedTitle, "Model title is not search result name")
    }

    func model(_ model: CitySearchResultModelImp, tapCommandIs expectedTapCommand: OpenDetailsCommandMock) {

        XCTAssertTrue(model.tapCommand === expectedTapCommand, "Model tap command is not tap command created by factory")
    }
}