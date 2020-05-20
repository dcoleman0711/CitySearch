//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class ParallaxViewFactoryMock: ParallaxViewFactory {

    var parallaxViewImp: (_ viewModel: ParallaxViewModel) -> ParallaxView = { viewModel in ParallaxViewMock() }
    func parallaxView(viewModel: ParallaxViewModel) -> ParallaxView {

        parallaxViewImp(viewModel)
    }
}
