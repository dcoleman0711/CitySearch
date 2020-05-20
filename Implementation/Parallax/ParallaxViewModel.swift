//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol ParallaxViewModel {

    func subscribeToContentOffset() -> ValueUpdate<CGPoint>

    func observeOffsets(_ observer: @escaping ValueUpdate<[CGPoint]>)
}

class ParallaxViewModelImp: ParallaxViewModel {

    private let model: ParallaxModel

    private let contentOffset = Observable<CGPoint>(.zero)

    convenience init() {

        self.init(model: ParallaxModelImp())
    }

    init(model: ParallaxModel) {

        self.model = model
    }

    func subscribeToContentOffset() -> ValueUpdate<CGPoint> {

        { contentOffset in self.contentOffset.value = contentOffset }
    }

    func observeOffsets(_ observer: @escaping ValueUpdate<[CGPoint]>) {

        let (offsetUpdate, layerUpdate) = zipUpdate(mapUpdate(observer, ParallaxViewModelImp.merge(self)))

        self.contentOffset.subscribe(offsetUpdate)
        self.model.observeLayers(layerUpdate)
    }

    func merge(_ offset: CGPoint, _ layers: [ParallaxLayer]) -> [CGPoint] {

        layers.map { layer in CGPoint(x: offset.x / layer.distance, y: offset.y / layer.distance) }
    }
}

