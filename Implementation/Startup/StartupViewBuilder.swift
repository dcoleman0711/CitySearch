//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupViewBuilder: class {

    var transitionCommand: StartupTransitionCommand { get set }
    var searchService: CitySearchService { get set }

    func build() -> StartupView
}

class StartupViewBuilderImp: StartupViewBuilder {

    var appTitleLabel = UILabel()
    var transitionCommand: StartupTransitionCommand = StartupTransitionCommandNull()
    var searchService: CitySearchService = CitySearchServiceImp()

    func build() -> StartupView {

        let model = StartupModelImp(timerType: Timer.self, transitionCommand: transitionCommand, searchService: searchService)
        let viewModel = StartupViewModelImp(model: model)
        return StartupViewImp(appTitleLabel: appTitleLabel, viewModel: viewModel, binder: ViewBinderImp())
    }
}