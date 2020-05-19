//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol OpenDetailsCommand: CellTapCommand {

    func invoke()
}

class OpenDetailsCommandImp: OpenDetailsCommand {

    private weak var searchView: SearchView?
    private let cityDetailsViewFactory: CityDetailsViewFactory
    private let searchResult: CitySearchResult

    init(searchView: SearchView?, cityDetailsViewFactory: CityDetailsViewFactory, searchResult: CitySearchResult) {

        self.searchView = searchView
        self.cityDetailsViewFactory = cityDetailsViewFactory
        self.searchResult = searchResult
    }

    func invoke() {

        let cityDetailsView = cityDetailsViewFactory.detailsView(searchResult: searchResult)
        self.searchView?.navigationController?.pushViewController(cityDetailsView, animated: true)
    }
}