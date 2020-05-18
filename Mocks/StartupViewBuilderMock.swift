//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class StartupViewBuilderMock: StartupViewBuilder {

    var transitionCommand: StartupTransitionCommand = StartupTransitionCommandMock()
    var searchService: CitySearchService = CitySearchServiceMock()

    var buildImp: () -> StartupViewImp = { StartupViewBuilderImp().build() }

    func build() -> StartupViewImp {

        buildImp()
    }
}
