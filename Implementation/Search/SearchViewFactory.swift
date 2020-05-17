//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchViewFactory {

    func searchView(initialData: CitySearchResults) -> SearchViewImp
}

class SearchViewFactoryImp: SearchViewFactory {

    func searchView(initialData: CitySearchResults) -> SearchViewImp {

        SearchViewImp(initialData: initialData)
    }
}