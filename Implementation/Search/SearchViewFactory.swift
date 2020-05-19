//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchViewFactory {

    func searchView(initialData: CitySearchResults) -> SearchView
}

class SearchViewFactoryImp: SearchViewFactory {

    func searchView(initialData: CitySearchResults) -> SearchView {

        let builder = SearchViewBuilder()
        builder.initialData = initialData
        return builder.build()
    }
}