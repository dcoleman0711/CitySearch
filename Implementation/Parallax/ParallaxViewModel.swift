//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol ParallaxViewModel {

    func subscribeToContentOffset() -> ValueUpdate<CGPoint>
}

class ParallaxViewModelImp: ParallaxViewModel {

    func subscribeToContentOffset() -> ValueUpdate<CGPoint> {

        { contentOffset in }
    }
}