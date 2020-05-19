//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchResultsViewFactory {

    func searchResultsView(model: SearchResultsModel) -> SearchResultsView
}

class SearchResultsViewFactoryImp: SearchResultsViewFactory {

    func searchResultsView(model: SearchResultsModel) -> SearchResultsView {

        SearchResultsViewImp(model: model)
    }
}
