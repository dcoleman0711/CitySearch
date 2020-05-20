//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class ParallaxViewModelFactoryMock: ParallaxViewModelFactory {

    var parallaxViewModelImp: () -> ParallaxViewModel = { ParallaxViewModelMock() }
    func parallaxViewModel() -> ParallaxViewModel {

        parallaxViewModelImp()
    }
}
