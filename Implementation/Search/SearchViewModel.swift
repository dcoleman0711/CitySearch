//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchViewModel {
}

class SearchViewModelImp: SearchViewModel {

    private let model: SearchModel
    private let parallaxViewModel: ParallaxViewModel
    private let searchResultsViewModel: SearchResultsViewModel

    init(model: SearchModel, parallaxViewModel: ParallaxViewModel, searchResultsViewModel: SearchResultsViewModel) {

        self.model = model
        self.parallaxViewModel = parallaxViewModel
        self.searchResultsViewModel = searchResultsViewModel

        connectParallaxlToSearchResults()
    }

    private func connectParallaxlToSearchResults() {

        searchResultsViewModel.observeContentOffset(parallaxViewModel.subscribeToContentOffset())
    }
}