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

    func testClearBackground() {

        let searchResultsView = when.createSearchResults()

        then.searchResultsViewHasClearBackground(searchResultsView)
    }

    func testFlowLayout() {

        let searchResultsView = when.createSearchResults()

        then.searchResultsViewHasHorizontallyScrollingFlowLayout(searchResultsView)
    }

    func testInitialSearchResultsData() {

        let searchResults = given.searchResults()
        let searchModels = given.searchCellData(for: searchResults)
        let searchViewModels = given.searchCellPresentation(for: searchModels)
        let searchResultCells = given.searchResultCells(for: searchViewModels)

        let searchView = when.createSearchResults(initialData: searchResults)

        then.searchResultsCells(searchResultCells, areDisplayedIn: searchView)
    }
    
    func testInitialSearchResultsSizes() {

        let searchResults = given.searchResults()
        let expectedCellSize = given.searchResultCellSize()
        
        let searchView = when.createSearchResults(initialData: searchResults)

        then.displayedCells(in: searchView, allHaveSize: expectedCellSize)
    }
}

class SearchResultsSteps {

    private let collectionView = UICollectionViewMock()

    private let resultModelFactory = CitySearchResultModelFactoryMock()
    private let resultViewModelFactory = CitySearchResultViewModelFactoryMock()

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

        CollectionViewTestUtilities.captureDisplayedData(from: collectionView, andStoreIn: &displayedResults)
    }

    func searchResults() -> CitySearchResults {

        CitySearchResultsStub.stubResults()
    }

    func searchResultCellSize() -> CGSize {

        CGSize(width: 128.0, height: 128.0)
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

    func createSearchResults(initialData: CitySearchResults = CitySearchResults(items: [])) -> SearchResultsViewImp {

        let model = SearchResultsModelImp(modelFactory: resultModelFactory, resultModels: Observable<[CitySearchResultModel]>([]))
        let viewModel = SearchResultsViewModelImp(model: model, viewModelFactory: resultViewModelFactory)
        model.setResults(initialData)

        return SearchResultsViewImp(collectionView: collectionView, viewModel: viewModel, binder: CollectionViewBinderImp<CitySearchResultViewModel, CitySearchResultCell>())
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

    func searchResultsViewHasClearBackground(_ searchView: SearchResultsViewImp) {

        XCTAssertEqual(searchView.view.backgroundColor, UIColor.clear, "Search Results background is not clear")
    }

    func searchResultsViewHasHorizontallyScrollingFlowLayout(_ searchResultsView: SearchResultsViewImp) {

        XCTAssertEqual((collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection, UICollectionView.ScrollDirection.horizontal, "Search results does not have a horizontally scrolling flow layout")
    }

    func displayedCells(in: SearchResultsViewImp, allHaveSize expectedSize: CGSize) {

        let size = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(self.collectionView, layout: self.collectionView.collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertEqual(size, expectedSize, "Displayed cells do not have the correct size")
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

class CollectionViewTestUtilities {

    static func captureDisplayedData<CellType: UICollectionViewCell>(from collectionView: UICollectionViewMock, andStoreIn results: UnsafeMutablePointer<[[CellType]]?>) {

        collectionView.reloadDataImp = {

            // Capture the data that the collection view would display, by imitating the calls that a real collection view would make
            guard let dataSource = collectionView.dataSource else {
                results.pointee = []
                return
            }

            let sectionCount = dataSource.numberOfSections?(in: collectionView) ?? 0
            let sectionIndices = [Int](0..<sectionCount)

            results.pointee = sectionIndices.map { sectionIndex -> [CellType] in

                let itemCount = dataSource.collectionView(collectionView, numberOfItemsInSection: sectionIndex)
                let itemIndices = [Int](0..<itemCount)

                return itemIndices.map { itemIndex -> CellType in

                    dataSource.collectionView(collectionView, cellForItemAt: IndexPath(item: itemIndex, section: sectionIndex)) as! CellType
                }
            }
        }
    }
}
