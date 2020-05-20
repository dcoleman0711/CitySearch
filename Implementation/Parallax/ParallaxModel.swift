//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

struct ParallaxLayer: Equatable {

    public let distance: CGFloat
    public let image: UIImage

    static func ==(lhs: ParallaxLayer, rhs: ParallaxLayer) -> Bool {

        lhs.distance == rhs.distance && UIImage.compareImages(lhs: lhs.image, rhs: rhs.image)
    }
}

protocol ParallaxModel {

    func observeLayers(_ observer: @escaping ValueUpdate<[ParallaxLayer]>)

    func setLayers(_ layers: [ParallaxLayer])
}

class ParallaxModelImp: ParallaxModel {

    private let layers = Observable<[ParallaxLayer]>([])

    func observeLayers(_ observer: @escaping ValueUpdate<[ParallaxLayer]>) {

        layers.subscribe(observer, updateImmediately: true)
    }

    func setLayers(_ layers: [ParallaxLayer]) {

        self.layers.value = layers
    }
}
