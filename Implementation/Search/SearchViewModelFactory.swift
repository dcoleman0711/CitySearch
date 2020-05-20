//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchViewModelFactory {

    func searchViewModel(model: SearchModel, parallaxViewModel: ParallaxViewModel, searchResultsViewModel: SearchResultsViewModel) -> SearchViewModel
}

class SearchViewModelFactoryImp : SearchViewModelFactory {

    func searchViewModel(model: SearchModel, parallaxViewModel: ParallaxViewModel, searchResultsViewModel: SearchResultsViewModel) -> SearchViewModel {

        SearchViewModelImp(model: model, parallaxViewModel: parallaxViewModel, searchResultsViewModel: searchResultsViewModel)
    }
}
