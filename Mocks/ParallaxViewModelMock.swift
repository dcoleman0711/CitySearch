//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class ParallaxViewModelMock : ParallaxViewModel {

    public var subscribeToContentOffsetImp: () -> ValueUpdate<CGPoint> = { { contentOffset in } }
    func subscribeToContentOffset() -> ValueUpdate<CGPoint> {

        subscribeToContentOffsetImp()
    }
}
