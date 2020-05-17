//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchViewFactoryMock : SearchViewFactory {

    var searchViewImp: (_ initialData: CitySearchResults) -> SearchViewImp = { (initialData) in SearchViewImp(initialData: initialData) }
    func searchView(initialData: CitySearchResults) -> SearchViewImp {

        searchViewImp(initialData)
    }
}
