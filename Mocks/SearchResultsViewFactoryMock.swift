//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchResultsViewFactoryMock: SearchResultsViewFactory {

    var searchResultsViewImp: (_ model: SearchResultsModel) -> SearchResultsView = { (model) in SearchResultsViewMock() }
    func searchResultsView(model: SearchResultsModel) -> SearchResultsView {

        searchResultsViewImp(model)
    }
}
