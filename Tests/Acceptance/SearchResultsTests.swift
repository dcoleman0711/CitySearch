//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class SearchResultsTests: XCTestCase {

    var steps: SearchResultsSteps!

    var given: SearchResultsSteps { steps }
    var when: SearchResultsSteps { steps }
    var then: SearchResultsSteps { steps }

    override func setUp() {

        super.setUp()

        steps = SearchResultsSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

//    func testInitialSearchResultsDisplayed() {
//
//        let searchResults = given.searchResults()
//        let searchModels = given.searchCellData(for: searchResults)
//        let searchViewModels = given.searchCellPresentation(for: searchModels)
//        let searchResultCells = given.searchResultCells(for: searchViewModels)
//
//        let searchView = when.createSearchView(initialData: searchResults)
//
//        then.searchResultsCells(searchResultCells, areDisplayedIn: searchView)
//    }
}

class SearchResultsSteps {

    private let collectionView = UICollectionViewMock()

    let resultModelFactory = CitySearchResultModelFactoryMock()
    let resultViewModelFactory = CitySearchResultViewModelFactoryMock()

    private var displayedResults: [[CitySearchResultCell]]?

    init() {

        var modelsMap: [String : CitySearchResultModelMock] = [:]
        resultModelFactory.resultModelImp = { (searchResult) in

            modelsMap[searchResult.name] ?? {

                let result = CitySearchResultModelMock()
                modelsMap[searchResult.name] = result
                return result
            }()
        }

        var viewModelsMap: [ObjectIdentifier : CitySearchResultViewModelMock] = [:]
        resultViewModelFactory.resultViewModelImp = { (model) in

            let modelID = ObjectIdentifier(model)
            return viewModelsMap[modelID] ?? {

                let result = CitySearchResultViewModelMock()
                viewModelsMap[modelID] = result
                return result
            }()
        }

        collectionView.reloadDataImp = {

            // Capture the data that the collection view would display, by imitating the calls that a real collection view would make
            guard let dataSource = self.collectionView.dataSource else {
                self.displayedResults = []
                return
            }

            let sectionCount = dataSource.numberOfSections?(in: self.collectionView) ?? 0
            let sectionIndices = [Int](0..<sectionCount)

            self.displayedResults = sectionIndices.map { sectionIndex -> [CitySearchResultCell] in

                let itemCount = dataSource.collectionView(self.collectionView, numberOfItemsInSection: sectionIndex)
                let itemIndices = [Int](0..<itemCount)

                return itemIndices.map { itemIndex -> CitySearchResultCell in

                    let cell = dataSource.collectionView(self.collectionView, cellForItemAt: IndexPath(item: itemIndex, section: sectionIndex)) as? CitySearchResultCell

                    return cell ?? CitySearchResultCellMock()
                }
            }
        }
    }

    func searchResults() -> CitySearchResults {

        CitySearchResultsStub.stubResults()
    }

    func searchCellData(for searchResults: CitySearchResults) -> [CitySearchResultModelMock] {

        searchResults.items.map( { resultModelFactory.resultModel(searchResult: $0) as! CitySearchResultModelMock } )
    }

    func searchCellPresentation(for searchModels: [CitySearchResultModelMock]) -> [CitySearchResultViewModelMock] {

        searchModels.map( { resultViewModelFactory.resultViewModel(model: $0) as! CitySearchResultViewModelMock } )
    }

    func searchResultCells(for viewModels: [CitySearchResultViewModelMock]) -> [CitySearchResultCellMock] {

        viewModels.map({ (viewModel) in

            let cell = CitySearchResultCellMock()
            cell.viewModel = viewModel
            return cell
        })
    }

    func createSearchView(initialData: CitySearchResults = CitySearchResults(items: [])) -> SearchResultsViewImp {

        let model = SearchResultsModelImp()
        model.setResults(initialData)
        return SearchResultsViewImp(model: model)
    }

    func searchScreenIsLoaded(_ searchView: SearchView) {

        searchView.loadViewIfNeeded()
    }

    func searchView(_ searchView: SearchView, sizeBecomes size: CGSize) {

        searchView.view.frame = CGRect(origin: CGPoint.zero, size: size)
        searchView.view.setNeedsLayout()
        searchView.view.layoutIfNeeded()
    }

    func searchResultsCells(_ expectedCells: [CitySearchResultCell], areDisplayedIn searchView: SearchResultsViewImp) {

        guard let displayedResults = self.displayedResults else {
            XCTFail("No results were displayed")
            return
        }

        let flattenedResults = [CitySearchResultCell](displayedResults.joined())

        XCTAssertTrue(flattenedResults.elementsEqual(expectedCells) { firstCell, secondCell in firstCell.viewModel === secondCell.viewModel }, "Displayed cells are not the expected cells")
    }
}

class UICollectionViewMock : UICollectionView {

    init() {

        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    var reloadDataImp: () -> Void = { }
    override func reloadData() {

        reloadDataImp()
    }
}