//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class SearchViewFactoryMock : SearchViewFactory {

    var searchViewImp: (_ initialData: CitySearchResults) -> SearchView = { (initialData) in SearchViewMock() }
    func searchView(initialData: CitySearchResults) -> SearchView {

        searchViewImp(initialData)
    }
}
