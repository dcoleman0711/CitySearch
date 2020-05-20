//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class ParallaxViewModelMock : ParallaxViewModel {

    var subscribeToContentOffsetImp: () -> ValueUpdate<CGPoint> = { { contentOffset in } }
    func subscribeToContentOffset() -> ValueUpdate<CGPoint> {

        subscribeToContentOffsetImp()
    }

    var observeImagesImp: (_ observer: @escaping ValueUpdate<[UIImage]>) -> Void = { observer in }
    func observeImages(_ observer: @escaping ValueUpdate<[UIImage]>) {

        observeImagesImp(observer)
    }

    var observeOffsetsImp: (_ observer: @escaping ValueUpdate<[CGPoint]>) -> Void = { observer in }
    func observeOffsets(_ observer: @escaping ValueUpdate<[CGPoint]>) {

        observeOffsetsImp(observer)
    }
}
