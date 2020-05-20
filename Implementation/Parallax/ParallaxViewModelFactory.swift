//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol ParallaxViewModelFactory {

    func parallaxViewModel(model: ParallaxModel) -> ParallaxViewModel
}

class ParallaxViewModelFactoryImp: ParallaxViewModelFactory {

    func parallaxViewModel(model: ParallaxModel) -> ParallaxViewModel {

        ParallaxViewModelImp(model: model)
    }
}