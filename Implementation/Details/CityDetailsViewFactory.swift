//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol CityDetailsViewFactory {

    func detailsView(searchResult: CitySearchResult) -> CityDetailsView
}

class CityDetailsViewFactoryImp: CityDetailsViewFactory {

    func detailsView(searchResult: CitySearchResult) -> CityDetailsView {

        CityDetailsViewImp()
    }
}