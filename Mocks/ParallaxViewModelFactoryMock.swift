//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class ParallaxViewModelFactoryMock: ParallaxViewModelFactory {

    var parallaxViewModelImp: (_ model: ParallaxModel) -> ParallaxViewModel = { model in ParallaxViewModelMock() }
    func parallaxViewModel(model: ParallaxModel) -> ParallaxViewModel {

        parallaxViewModelImp(model)
    }
}
