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
        let searchResultCells = given.searchResultCells(for: searchResults)

        let searchView = when.createSearchResults(initialData: searchResults)

        then.searchResultsCells(searchResultCells, areDisplayedIn: searchView)
    }
    
    func testInitialSearchResultsSizes() {

        let searchResults = given.searchResults()
        let expectedCellSize = given.searchResultCellSize()
        
        let searchView = when.createSearchResults(initialData: searchResults)

        then.displayedCells(in: searchView, allHaveSize: expectedCellSize)
    }

    func testTapCellToOpenDetails() {

        let searchResults = given.searchResults()
        let searchResult = given.searchResult(in: searchResults)
        let openDetailsCommand = given.openDetailsCommand(for: searchResult)
        let searchView = given.createSearchResults(initialData: searchResults)

        when.cellIsTapped(displaying: searchResult, in: searchView)

        then.openDetailsCommandIsInvoked(openDetailsCommand)
    }
}

class SearchResultsSteps {

    private let collectionView = UICollectionViewMock()

    private let resultModelFactory = CitySearchResultModelFactoryMock()
    private let resultViewModelFactory = CitySearchResultViewModelFactoryMock()

    private let openDetailsCommandFactory = OpenDetailsCommandFactoryMock()

    private var displayedResults: [[CitySearchResultCell]]?

    private var invokedOpenDetailsCommand: OpenDetailsCommandMock?

    init() {

        var modelsMap: [String : CitySearchResultModelMock] = [:]
        resultModelFactory.resultModelImp = { (searchResult, tapCommandFactory) in

            modelsMap[searchResult.name] ?? {

                let result = CitySearchResultModelMock()
                result.tapCommand = tapCommandFactory.openDetailsCommand(for: searchResult)
                modelsMap[searchResult.name] = result
                return result
            }()
        }

        var viewModelsMap: [ObjectIdentifier : CitySearchResultViewModelMock] = [:]
        resultViewModelFactory.resultViewModelImp = { (model) in

            let modelID = ObjectIdentifier(model)
            return viewModelsMap[modelID] ?? {

                let result = CitySearchResultViewModelMock()
                result.tapCommand = model.tapCommand
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

    func searchResultCells(for searchResults: CitySearchResults) -> [CitySearchResultCellMock] {

        searchResults.results.map({ (searchResult) in

            let model = resultModelFactory.resultModel(searchResult: searchResult, tapCommandFactory: openDetailsCommandFactory)
            let viewModel = resultViewModelFactory.resultViewModel(model: model)
            let cell = CitySearchResultCellMock()
            cell.viewModel = viewModel
            return cell
        })
    }

    func createSearchResults(initialData: CitySearchResults = CitySearchResults(results: [])) -> SearchResultsViewImp {

        let model = SearchResultsModelImp(modelFactory: resultModelFactory, openDetailsCommandFactory: openDetailsCommandFactory, resultModels: Observable<[CitySearchResultModel]>([]))
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

    func searchResult(in searchResults: CitySearchResults) -> CitySearchResult {

        searchResults.results[searchResults.results.count / 2]
    }

    func openDetailsCommand(for searchResult: CitySearchResult) -> OpenDetailsCommandMock {

        let command = OpenDetailsCommandMock()

        command.invokeImp = {

            self.invokedOpenDetailsCommand = command
        }

        openDetailsCommandFactory.openDetailsCommandImp = { result in

            if result == searchResult { return command }

            return OpenDetailsCommandMock()
        }

        return command
    }

    func cellIsTapped(displaying result: CitySearchResult, in searchView: SearchResultsViewImp) {

        let model = resultModelFactory.resultModel(searchResult: result, tapCommandFactory: OpenDetailsCommandFactoryMock())
        let viewModel = resultViewModelFactory.resultViewModel(model: model)

        let indexPath = (displayedResults?.enumerated().compactMap { sectionIndex, section -> IndexPath? in

            section.enumerated().compactMap { rowIndex, cell -> IndexPath? in

                guard cell.viewModel === viewModel else { return nil }

                return IndexPath(item: rowIndex, section: sectionIndex)

            }.first

        }.first)!

        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
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

    func openDetailsCommandIsInvoked(_ detailsCommand: OpenDetailsCommandMock) {

        XCTAssertTrue(invokedOpenDetailsCommand === detailsCommand, "Open Details command was not invoked")
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
