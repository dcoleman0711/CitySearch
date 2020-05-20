//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol ParallaxViewModelFactory {

    func parallaxViewModel() -> ParallaxViewModel
}

class ParallaxViewModelFactoryImp: ParallaxViewModelFactory {

    func parallaxViewModel() -> ParallaxViewModel {

        ParallaxViewModelImp()
    }
}