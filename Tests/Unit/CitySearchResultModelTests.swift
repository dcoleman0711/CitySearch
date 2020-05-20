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

        let searchResult = given.searchResult()

        let model = when.modelIsCreated(searchResult: searchResult)

        then.model(model, titleIs: searchResult.name)
    }

    func testPopulationClass() {

        let searchResult = given.searchResult()
        let populationClass = given.populationClass(for: searchResult)

        let model = when.modelIsCreated(searchResult: searchResult)

        then.model(model, populationClassIs: populationClass)
    }

    func testTapCommand() {

        let searchResult = given.searchResult()
        let tapCommandFactory = given.tapCommandFactory()
        let tapCommand = given.tapCommand(createdBy: tapCommandFactory, for: searchResult)

        let model = when.modelIsCreated(searchResult: searchResult, tapCommandFactory: tapCommandFactory)

        then.model(model, tapCommandIs: tapCommand)
    }
}

class CitySearchResultModelSteps {

    func searchResult() -> CitySearchResult {

        // This only tests one population class.  There should be one test for each class that produces a distinct output
        CitySearchResult(name: "Test City", population: 100000)
    }

    func populationClass(for searchResult: CitySearchResult) -> PopulationClass {

        ([PopulationClassSmall(), PopulationClassMedium(), PopulationClassLarge(), PopulationClassVeryLarge()].first { populationClass in

            populationClass.range.contains(searchResult.population)
        })!
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

    func model(_ model: CitySearchResultModelImp, populationClassIs expectedPopulationClass: PopulationClass) {

        XCTAssertTrue(model.populationClass.equals(expectedPopulationClass), "Model population class is not correct")
    }

    func model(_ model: CitySearchResultModelImp, tapCommandIs expectedTapCommand: OpenDetailsCommandMock) {

        XCTAssertTrue(model.tapCommand === expectedTapCommand, "Model tap command is not tap command created by factory")
    }
}