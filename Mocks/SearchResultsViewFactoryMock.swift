//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchResultsViewFactoryMock: SearchResultsViewFactory {

    var searchResultsViewImp: (_ openDetailsCommandFactory: OpenDetailsCommandFactory) -> SearchResultsView = { (openDetailsCommandFactory) in SearchResultsViewMock() }
    func searchResultsView(openDetailsCommandFactory: OpenDetailsCommandFactory) -> SearchResultsView {

        searchResultsViewImp(openDetailsCommandFactory)
    }
}
