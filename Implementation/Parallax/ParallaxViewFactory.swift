//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol ParallaxViewFactory {

    func parallaxView(viewModel: ParallaxViewModel) -> ParallaxView
}

class ParallaxViewFactoryImp: ParallaxViewFactory {

    func parallaxView(viewModel: ParallaxViewModel) -> ParallaxView {

        ParallaxViewImp(viewModel: viewModel)
    }
}