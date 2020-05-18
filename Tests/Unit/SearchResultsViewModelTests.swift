//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class SearchResultsViewModelTests: XCTestCase {

    var steps: SearchResultsViewModelSteps!

    var given: SearchResultsViewModelSteps { steps }
    var when: SearchResultsViewModelSteps { steps }
    var then: SearchResultsViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = SearchResultsViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testObserveSearchResultsImmediate() {

        let model = given.searchResultsModel()
        let viewModel = given.searchResultsViewModelCreated(model: model)
        let resultModels = given.resultModels()
        let resultViewModels = given.resultViewModels(for: resultModels)
        let cellSize = given.cellSize()
        let resultsData = given.resultsData(for: resultViewModels, cellSize)
        let observer = given.resultsObserver()
        given.model(model, updatedResultsTo: resultModels)

        when.observeSearchResults(viewModel, observer)

        then.observer(observer, isNotifiedWith: resultsData)
    }

    func testObserveSearchResultsUpdate() {

        let model = given.searchResultsModel()
        let viewModel = given.searchResultsViewModelCreated(model: model)
        let resultModels = given.resultModels()
        let resultViewModels = given.resultViewModels(for: resultModels)
        let cellSize = given.cellSize()
        let resultsData = given.resultsData(for: resultViewModels, cellSize)
        let observer = given.resultsObserver()
        given.observeSearchResults(viewModel, observer)

        when.model(model, updatedResultsTo: resultModels)

        then.observer(observer, isNotifiedWith: resultsData)
    }
}

class SearchResultsViewModelSteps {

    private let resultViewModelFactory = CitySearchResultViewModelFactoryMock()

    private var valuePassedToObserver: [CellData<CitySearchResultViewModel>]?
    private var modelObserver: ValueUpdate<[CitySearchResultModel]>?

    func resultViewModels(for resultModels: [CitySearchResultModelMock]) -> [CitySearchResultViewModelMock] {

        var viewModelsMap: [ObjectIdentifier : CitySearchResultViewModelMock] = [:]
        resultViewModelFactory.resultViewModelImp = { (model) in

            let modelID = ObjectIdentifier(model)
            return viewModelsMap[modelID] ?? {

                let result = CitySearchResultViewModelMock()
                viewModelsMap[modelID] = result
                return result
            }()
        }

        return resultModels.map( { resultViewModelFactory.resultViewModel(model: $0) as! CitySearchResultViewModelMock } )
    }

    func resultsObserver() -> ValueUpdate<[CellData<CitySearchResultViewModel>]> {

        { (value) in

            self.valuePassedToObserver = value
        }
    }

    func searchResultsViewModelCreated(model: SearchResultsModelMock) -> SearchResultsViewModelImp {

        SearchResultsViewModelImp(model: model, viewModelFactory: resultViewModelFactory)
    }

    func searchResultsModel() -> SearchResultsModelMock {

        let model = SearchResultsModelMock()

        model.observeResultsModelsImp = { (observer) in

            self.modelObserver = observer
        }

        return model
    }

    func model(_ model: SearchResultsModelMock, updatedResultsTo resultModels: [CitySearchResultModelMock]) {

        modelObserver?(resultModels)
    }

    func resultModels() -> [CitySearchResultModelMock] {

        (0..<5).map({ _ in CitySearchResultModelMock() })
    }

    func cellSize() -> CGSize {

        CGSize(width: 128.0, height: 128.0)
    }

    func resultsData(for viewModels: [CitySearchResultViewModelMock], _ cellSize: CGSize) -> [CellData<CitySearchResultViewModel>] {

        viewModels.map({ viewModel in CellData<CitySearchResultViewModel>(viewModel: viewModel, size: cellSize) })
    }

    func observeSearchResults(_ viewModel: SearchResultsViewModelImp, _ observer: @escaping ValueUpdate<[CellData<CitySearchResultViewModel>]>) {

        viewModel.observeResultsViewModels(observer)
    }

    func observer(_ observer: ValueUpdate<[CellData<CitySearchResultViewModel>]>, isNotifiedWith expectedResults: [CellData<CitySearchResultViewModel>]) {

        XCTAssertTrue(valuePassedToObserver?.elementsEqual(expectedResults) { first, second in first.viewModel === second.viewModel && first.size == second.size } ?? false, "Observer was not notified of correct results")
    }
}