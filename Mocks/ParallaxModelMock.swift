//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class ParallaxModelMock: ParallaxModel {

    var observeLayersImp: (_ observer: @escaping ValueUpdate<[ParallaxLayer]>) -> Void = { observer in }
    func observeLayers(_ observer: @escaping ValueUpdate<[ParallaxLayer]>) {

        observeLayersImp(observer)
    }

    var setLayersImp: (_ layers: [ParallaxLayer]) -> Void = { layers in }
    func setLayers(_ layers: [ParallaxLayer]) {

        setLayersImp(layers)
    }
}
