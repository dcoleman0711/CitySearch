//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class SearchViewModelTests: XCTestCase {

    var steps: SearchViewModelSteps!

    var given: SearchViewModelSteps { steps }
    var when: SearchViewModelSteps { steps }
    var then: SearchViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = SearchViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testConnectParallaxToSearchResults() {

        let parallaxViewModel = given.parallaxViewModel()
        let searchResultsViewModel = given.searchResultsViewModel()
        let contentOffset = given.contentOffset()
        let searchViewModel = given.searchViewModelIsCreated(parallaxViewModel: parallaxViewModel, searchResultsViewModel: searchResultsViewModel)

        when.searchResultsViewModel(searchResultsViewModel, publishesContentOffset: contentOffset)

        then.parallaxViewModel(parallaxViewModel, receivesContentOffset: contentOffset)
    }
}

class SearchViewModelSteps {

    private var contentOffsetReceivedByParallaxViewModel: CGPoint?
    private var searchResultsContentOffsetObserver: ValueUpdate<CGPoint>?

    func parallaxViewModel() -> ParallaxViewModelMock {

        let parallaxViewModel = ParallaxViewModelMock()

        parallaxViewModel.subscribeToContentOffsetImp = {

            { contentOffset in

                self.contentOffsetReceivedByParallaxViewModel = contentOffset
            }
        }

        return parallaxViewModel
    }

    func searchResultsViewModel() -> SearchResultsViewModelMock {

        let searchResultsViewModel = SearchResultsViewModelMock()

        searchResultsViewModel.observeContentOffsetImp = { observer in

            self.searchResultsContentOffsetObserver = observer
        }

        return searchResultsViewModel
    }

    func contentOffset() -> CGPoint {

        CGPoint(x: 56.0, y: 0.0)
    }

    func searchViewModelIsCreated(parallaxViewModel: ParallaxViewModelMock, searchResultsViewModel: SearchResultsViewModelMock) -> SearchViewModelImp {

        SearchViewModelImp(model: SearchModelMock(), parallaxViewModel: parallaxViewModel, searchResultsViewModel: searchResultsViewModel)
    }

    func searchResultsViewModel(_ viewModel: SearchResultsViewModelMock, publishesContentOffset contentOffset: CGPoint) {

        searchResultsContentOffsetObserver?(contentOffset)
    }

    func parallaxViewModel(_ viewModel: ParallaxViewModelMock, receivesContentOffset expectedContentOffset: CGPoint) {

        XCTAssertEqual(contentOffsetReceivedByParallaxViewModel, expectedContentOffset, "Content offset published by search results was not received by parallax")
    }
}