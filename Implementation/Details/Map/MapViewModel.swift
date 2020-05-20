//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol MapViewModel: class {

    func observeBackgroundImage(_ observer: ValueUpdate<UIImage>)
}

class MapViewModelImp: MapViewModel {

    func observeBackgroundImage(_ observer: ValueUpdate<UIImage>) {


    }
}
