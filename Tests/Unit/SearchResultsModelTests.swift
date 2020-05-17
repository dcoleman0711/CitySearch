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

    func testObserveSearchResultsInitial() {

        let resultModels = given.resultModels()
        let searchResults = given.searchResults()
        let expectedSearchModels = given.models(for: searchResults)
        let searchModel = given.searchResultsModelCreated(resultModels: resultModels)
        given.searchResultsModel(searchModel, dataIsSetTo: searchResults)
        let observer = given.resultsObserver()

        when.observeSearchResults(searchModel, observer)

        then.observerIsNotified(observer, withValue: expectedSearchModels)
    }
}

class SearchResultsModelSteps {

    private let resultModelFactory = CitySearchResultModelFactoryMock()

    private var valuePassedToObserver: [CitySearchResultModel]?

    func resultModels() -> ObservableMock<[CitySearchResultModel]> {

        let resultModels = ObservableMock<[CitySearchResultModel]>([])

        resultModels.subscribeImp = { (listener, updateImmediately) in

            if updateImmediately {

                listener(resultModels.value)
            }
        }

        return resultModels
    }

    func emptyResults() -> CitySearchResults {

        CitySearchResults.emptyResults()
    }

    func searchResults() -> CitySearchResults {

        CitySearchResultsStub.stubResults()
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

        return searchResults.items.map( { resultModelFactory.resultModel(searchResult: $0) as! CitySearchResultModelMock } )
    }

    func resultsObserver() -> ValueUpdate<[CitySearchResultModel]> {

        { (value) in

            self.valuePassedToObserver = value
        }
    }

    func searchResultsModelCreated(resultModels: ObservableMock<[CitySearchResultModel]>) -> SearchResultsModelImp {

        SearchResultsModelImp(modelFactory: resultModelFactory, resultModels: resultModels)
    }

    func searchResultsModel(_ searchResultsModel: SearchResultsModelImp, dataIsSetTo searchResults: CitySearchResults) {

        searchResultsModel.setResults(searchResults)
    }

    func observeSearchResults(_ model: SearchResultsModelImp, _ observer: ValueUpdate<[CitySearchResultModel]>) {

        model.observeResultsModels(observer)
    }

    func observerIsNotified(_ observer: ValueUpdate<[CitySearchResultModel]>, withValue expectedValue: [CitySearchResultModel]) {

        XCTAssertTrue(valuePassedToObserver?.elementsEqual(expectedValue) { (firstModel, secondModel) in firstModel === secondModel } ?? false, "Observer was not notified of correct results")
    }
}