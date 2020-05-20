//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class MapViewModelMock : MapViewModel {

    var observeBackgroundImageImp: (_ observer: ValueUpdate<UIImage>) -> Void = { observer in }
    func observeBackgroundImage(_ observer: ValueUpdate<UIImage>) {

        observeBackgroundImageImp(observer)
    }
}
