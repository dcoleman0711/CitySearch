//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchViewModelFactoryMock: SearchViewModelFactory {

    var searchViewModelImp: (_ model: SearchModel, _ parallaxViewModel: ParallaxViewModel, _ searchResultsViewModel: SearchResultsViewModel) -> SearchViewModel = { model, parallaxViewModel, searchResultsViewModel in SearchViewModelMock()}
    func searchViewModel(model: SearchModel, parallaxViewModel: ParallaxViewModel, searchResultsViewModel: SearchResultsViewModel) -> SearchViewModel {

        searchViewModelImp(model, parallaxViewModel, searchResultsViewModel)
    }
}
