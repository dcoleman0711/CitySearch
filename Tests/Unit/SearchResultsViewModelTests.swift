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

    func testSubscribeToContentOffset() {

        let model = given.searchResultsModel()
        let viewModel = given.searchResultsViewModelCreated(model: model)
        let contentOffset = given.contentOffset()
        let contentOffsetObserver = given.contentOffsetObserver()
        given.contentOffsetObserver(contentOffsetObserver, observesContentOffsetOn: viewModel)

        when.viewModel(viewModel, isNotifiedOfContentOffsetUpdateTo: contentOffset)

        then.contentOffsetObserver(contentOffsetObserver, isNotifiedWith: contentOffset)
    }
}

class SearchResultsViewModelSteps {

    private var updatedContentOffset: CGPoint?

    private let resultViewModelFactory = CitySearchResultViewModelFactoryMock()

    private var valuePassedToObserver: CollectionViewModel<CitySearchResultViewModel>?
    private var modelObserver: ValueUpdate<[CitySearchResultModel]>?

    private var updatedResultModels: [CitySearchResultModelMock] = []

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

    func resultsObserver() -> ValueUpdate<CollectionViewModel<CitySearchResultViewModel>> {

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
            observer(self.updatedResultModels)
        }

        return model
    }

    func contentOffset() -> CGPoint {

        CGPoint(x: 435.0, y: 0.0)
    }

    func contentOffsetObserver() -> ValueUpdate<CGPoint> {

        { contentOffset in

            self.updatedContentOffset = contentOffset
        }
    }

    func contentOffsetObserver(_ contentOffsetObserver: @escaping ValueUpdate<CGPoint>, observesContentOffsetOn viewModel: SearchResultsViewModelImp) {

        viewModel.observeContentOffset(contentOffsetObserver)
    }

    func model(_ model: SearchResultsModelMock, updatedResultsTo resultModels: [CitySearchResultModelMock]) {

        self.updatedResultModels = resultModels
        modelObserver?(resultModels)
    }

    func resultModels() -> [CitySearchResultModelMock] {

        (0..<5).map({ _ in CitySearchResultModelMock() })
    }

    func cellSize() -> CGSize {

        CGSize(width: 128.0, height: 128.0)
    }

    func resultsData(for viewModels: [CitySearchResultViewModelMock], _ cellSize: CGSize) -> CollectionViewModel<CitySearchResultViewModel> {

        let cells = viewModels.map({ viewModel in CellData<CitySearchResultViewModel>(viewModel: viewModel, size: cellSize, tapCommand: viewModel.tapCommand) })
        return CollectionViewModel<CitySearchResultViewModel>(cells: cells, itemSpacing: 0.0, lineSpacing: 0.0)
    }

    func observeSearchResults(_ viewModel: SearchResultsViewModelImp, _ observer: @escaping ValueUpdate<CollectionViewModel<CitySearchResultViewModel>>) {

        viewModel.observeResultsViewModels(observer)
    }

    func viewModel(_ viewModel: SearchResultsViewModelImp, isNotifiedOfContentOffsetUpdateTo contentOffset: CGPoint) {

        let observer = viewModel.subscribeToContentOffset()
        observer(contentOffset)
    }

    func observer(_ observer: ValueUpdate<CollectionViewModel<CitySearchResultViewModel>>, isNotifiedWith expectedResults: CollectionViewModel<CitySearchResultViewModel>) {

        XCTAssertTrue(valuePassedToObserver?.cells.elementsEqual(expectedResults.cells) { first, second in first.viewModel === second.viewModel && first.size == second.size && first.tapCommand === second.tapCommand } ?? false, "Observer was not notified of correct results")
    }

    func contentOffsetObserver(_ contentOffsetObserver: ValueUpdate<CGPoint>, isNotifiedWith expectedContentOffset: CGPoint) {

        XCTAssertEqual(updatedContentOffset, expectedContentOffset, "Content offset update was not published")
    }

}