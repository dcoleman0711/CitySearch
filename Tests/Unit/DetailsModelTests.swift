//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit
import Combine

class DetailsModelTests: XCTestCase {

    var steps: DetailsModelSteps!

    var given: DetailsModelSteps { steps }
    var when: DetailsModelSteps { steps }
    var then: DetailsModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = DetailsModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTitleText() {

        let searchResult = given.searchResult()
        let titleText = given.titleText(for: searchResult)
        let detailsModel = given.detailsModelIsCreated(for: searchResult)
        let textObserver = given.textObserver()

        when.observer(textObserver, observesTitleOn: detailsModel)

        then.observedText(on: textObserver, isEqualTo: titleText)
    }

    func testPopulation() {

        let searchResult = given.searchResult()
        let population = given.population(for: searchResult)
        let detailsModel = given.detailsModelIsCreated(for: searchResult)
        let intObserver = given.intObserver()

        when.observer(intObserver, observesPopulationOn: detailsModel)

        then.observedInt(on: intObserver, isEqualTo: population)
    }

    func testRequestImageSearch() {

        let searchResult = given.searchResult()
        let imageSearchService = given.imageSearchService()
        let query = given.imageSearchQuery(for: searchResult)

        let detailsModel = when.detailsModelIsCreated(for: searchResult, imageSearchService: imageSearchService)

        then.imageSearch(for: query, isRequestedWith: imageSearchService)
    }
}

class DetailsModelSteps {

    private let titleTextObservable = ObservableMock<String>("")
    private let populationObservable = ObservableMock<Int>(0)

    private var observedText: String?
    private var observedInt: Int?

    private var imageSearchQuery: String?

    init() {

        var textValue = ""

        titleTextObservable.valueSetter = { text in textValue = text }

        titleTextObservable.subscribeImp = { observer, updateImmediately in

            if updateImmediately {

                observer(textValue)
            }
        }

        var intValue = 0

        populationObservable.valueSetter = { int in intValue = int }

        populationObservable.subscribeImp = { observer, updateImmediately in

            if updateImmediately {

                observer(intValue)
            }
        }
    }

    func searchResult() -> CitySearchResult {

        CitySearchResultsStub.stubResults().results[0]
    }

    func titleText(for searchResult: CitySearchResult) -> String {

        searchResult.name
    }

    func population(for searchResult: CitySearchResult) -> Int {

        searchResult.population
    }

    func imageSearchService() -> ImageSearchServiceMock {

        let searchService = ImageSearchServiceMock()

        searchService.imageSearchImp = { query in

            self.imageSearchQuery = query

            return Future<ImageSearchResults, Error>({ promise in }).eraseToAnyPublisher()
        }

        return searchService
    }

    func imageSearchQuery(for city: CitySearchResult) -> String {

        city.name
    }

    func detailsModelIsCreated(for searchResult: CitySearchResult, imageSearchService: ImageSearchServiceMock = ImageSearchServiceMock()) -> CityDetailsModelImp {

        CityDetailsModelImp(searchResult: searchResult, imageSearchService: imageSearchService, titleText: titleTextObservable, population: populationObservable)
    }

    func textObserver() -> ValueUpdate<String> {

        { text in

            self.observedText = text
        }
    }

    func intObserver() -> ValueUpdate<Int> {

        { int in

            self.observedInt = int
        }
    }

    func observer(_ observer: @escaping ValueUpdate<String>, observesTitleOn model: CityDetailsModelImp) {

        model.observeTitleText(observer)
    }

    func observer(_ observer: @escaping ValueUpdate<Int>, observesPopulationOn model: CityDetailsModelImp) {

        model.observePopulation(observer)
    }

    func observedText(on observer: ValueUpdate<String>, isEqualTo expectedText: String) {

        XCTAssertEqual(observedText, expectedText, "Observed text is not correct")
    }

    func observedInt(on observer: ValueUpdate<Int>, isEqualTo expectedInt: Int) {

        XCTAssertEqual(observedInt, expectedInt, "Observed int is not correct")
    }

    func imageSearch(for expectedQuery: String, isRequestedWith searchService: ImageSearchServiceMock) {

        XCTAssertEqual(imageSearchQuery, expectedQuery, "Image search request was not made with expected query")
    }
}