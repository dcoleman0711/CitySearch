//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class SearchResultsModelTests: XCTestCase {

    var steps: SearchResultsModelSteps!

    var given: SearchResultsModelSteps { steps }
    var when: SearchResultsModelSteps { steps }
    var then: SearchResultsModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = SearchResultsModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testObserveSearchResultsImmediate() {

        let resultModelsObservable = given.resultModelsObservable()
        let searchModel = given.searchResultsModelCreated(resultModels: resultModelsObservable)
        let observer = given.resultsObserver()

        when.observeSearchResults(searchModel, observer)

        then.observerIsNotifiedImmediately(observer)
    }

    func testObserveSearchResultsUpdate() {

        let resultModelsObservable = given.resultModelsObservable()
        let resultModels = given.resultModels()
        let searchModel = given.searchResultsModelCreated(resultModels: resultModelsObservable)
        let observer = given.resultsObserver()
        given.observeSearchResults(searchModel, observer)

        when.resultModels(resultModelsObservable, isUpdatedTo: resultModels)

        then.observerIsNotified(observer, ofNewValue: resultModels)
    }

    func testSetResults() {

        let searchResults = given.searchResults()
        let expectedResultModels = given.models(for: searchResults)
        let resultModels = given.resultModelsObservable()
        let searchModel = given.searchResultsModelCreated(resultModels: resultModels)

        when.setResults(searchModel, searchResults)

        // Good example of the same step being a "when" in one test (the previous one) and a "then" in another test (this one).  Making something happen isn't the same as checking that it did happen, so I made a slightly renamed function.  There are other ways to handle this, like separating the assertions into another class (but then you have to deal with passing state between these classes)
        then.resultModels(resultModels, isSetTo: expectedResultModels)
    }
}

class SearchResultsModelSteps {

    private let resultModelFactory = CitySearchResultModelFactoryMock()

    private var valuePassedToObserver: [CitySearchResultModel]?

    private var listenerPassedToObservable: ValueUpdate<[CitySearchResultModel]>?
    private var listenerIsNotifiedImmediately = false

    private var resultModelsValue: [CitySearchResultModel] = []

    func resultModelsObservable() -> ObservableMock<[CitySearchResultModel]> {

        let resultModels = ObservableMock<[CitySearchResultModel]>([])

        resultModels.subscribeImp = { (listener, updateImmediately) in

            self.listenerPassedToObservable = listener
            self.listenerIsNotifiedImmediately = updateImmediately
        }

        resultModels.valueSetter = { (newValue) in

            self.resultModelsValue = newValue
        }

        return resultModels
    }

    func emptyResults() -> CitySearchResults {

        CitySearchResults.emptyResults()
    }

    func searchResults() -> CitySearchResults {

        CitySearchResultsStub.stubResults()
    }

    func resultModels() -> [CitySearchResultModelMock] {

        (0..<5).map({ _ in CitySearchResultModelMock() })
    }

    func models(for searchResults: CitySearchResults) -> [CitySearchResultModelMock] {

        var modelsMap: [String : CitySearchResultModelMock] = [:]
        resultModelFactory.resultModelImp = { (searchResult) in

            modelsMap[searchResult.name] ?? {

                let result = CitySearchResultModelMock()
                modelsMap[searchResult.name] = result
                return result
            }()
        }

        return searchResults.results.map( { resultModelFactory.resultModel(searchResult: $0) as! CitySearchResultModelMock } )
    }

    func resultsObserver() -> ValueUpdate<[CitySearchResultModel]> {

        { (value) in

            self.valuePassedToObserver = value
        }
    }

    func searchResultsModelCreated(resultModels: ObservableMock<[CitySearchResultModel]>) -> SearchResultsModelImp {

        SearchResultsModelImp(modelFactory: resultModelFactory, openDetailsCommandFactory: OpenDetailsCommandFactoryMock(), resultModels: resultModels)
    }

    func searchResultsModel(_ searchResultsModel: SearchResultsModelImp, dataIsSetTo searchResults: CitySearchResults) {

        searchResultsModel.setResults(searchResults)
    }

    func resultModels(_ resultModelsObservable: ObservableMock<[CitySearchResultModel]>, isUpdatedTo resultModels: [CitySearchResultModel]) {

        listenerPassedToObservable?(resultModels)
    }

    func observeSearchResults(_ model: SearchResultsModelImp, _ observer: @escaping ValueUpdate<[CitySearchResultModel]>) {

        model.observeResultsModels(observer)
    }

    func setResults(_ model: SearchResultsModelImp, _ results: CitySearchResults) {

        model.setResults(results)
    }

    func observerIsNotifiedImmediately(_ observer: ValueUpdate<[CitySearchResultModel]>) {

        XCTAssertTrue(listenerIsNotifiedImmediately, "Observer was not notified immediately")
    }

    func observerIsNotified(_ observer: ValueUpdate<[CitySearchResultModel]>, ofNewValue newValue: [CitySearchResultModel]) {

        XCTAssertTrue(valuePassedToObserver?.elementsEqual(newValue) { (firstModel, secondModel) in firstModel === secondModel } ?? false, "Observer was not notified of correct results")
    }

    func resultModels(_ resultModels: ObservableMock<[CitySearchResultModel]>, isSetTo expectedResults: [CitySearchResultModelMock]) {

        XCTAssertTrue(resultModelsValue.elementsEqual(expectedResults) { (firstModel, secondModel) in firstModel === secondModel } ?? false, "Result models was not set to expected value")
    }
}