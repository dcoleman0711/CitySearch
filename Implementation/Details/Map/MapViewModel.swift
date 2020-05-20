//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol MapViewModel: class {

    func observeBackgroundImage(_ observer: ValueUpdate<UIImage>)
}

class MapViewModelImp: MapViewModel {

    private let backgroundImage = ImageLoader.loadImage(name: "MapBackground.jpg")!

    convenience init() {

        self.init(model: MapModelImp())
    }

    init(model: MapModel) {

    }

    func observeBackgroundImage(_ observer: ValueUpdate<UIImage>) {

        observer(backgroundImage)
    }
}
