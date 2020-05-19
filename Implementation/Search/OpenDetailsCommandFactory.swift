//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol OpenDetailsCommandFactory: class {

    func openDetailsCommand(for searchResult: CitySearchResult) -> OpenDetailsCommand
}

class OpenDetailsCommandFactoryImp: OpenDetailsCommandFactory {

    private let cityDetailsViewFactory: CityDetailsViewFactory

    weak var searchView: SearchView?

    init(cityDetailsViewFactory: CityDetailsViewFactory) {

        self.cityDetailsViewFactory = cityDetailsViewFactory
    }

    func openDetailsCommand(for searchResult: CitySearchResult) -> OpenDetailsCommand {

        OpenDetailsCommandImp(searchView: searchView, cityDetailsViewFactory: cityDetailsViewFactory, searchResult: searchResult)
    }
}