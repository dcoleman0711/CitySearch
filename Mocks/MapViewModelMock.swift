//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class MapViewModelMock : MapViewModel {

    var observeBackgroundImageImp: (_ observer: @escaping ValueUpdate<UIImage>) -> Void = { observer in }
    func observeBackgroundImage(_ observer: @escaping ValueUpdate<UIImage>) {

        observeBackgroundImageImp(observer)
    }

    var observeMarkerImageImp: (_ observer: @escaping ValueUpdate<UIImage>) -> Void = { observer in }
    func observeMarkerImage(_ observer: @escaping ValueUpdate<UIImage>) {

        observeMarkerImageImp(observer)
    }

    var observeMarkerPositionImp: (_ observer: @escaping ValueUpdate<CGPoint>) -> Void = { observer in }
    func observeMarkerPosition(_ observer: @escaping ValueUpdate<CGPoint>) {

        observeMarkerPositionImp(observer)
    }
}
