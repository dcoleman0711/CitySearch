//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchResultsViewFactoryMock: SearchResultsViewFactory {

    var searchResultsViewImp: (_ viewModel: SearchResultsViewModel) -> SearchResultsView = { (viewModel) in SearchResultsViewMock() }
    func searchResultsView(viewModel: SearchResultsViewModel) -> SearchResultsView {

        searchResultsViewImp(viewModel)
    }
}
