//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol ParallaxViewModel {

    func subscribeToContentOffset() -> ValueUpdate<CGPoint>

    func observeImages(_ observer: @escaping ValueUpdate<[UIImage]>)

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

    func observeImages(_ observer: @escaping ValueUpdate<[UIImage]>) {

        self.model.observeLayers(mapUpdate(observer, ParallaxViewModelImp.mapLayers(self)))
    }

    func observeOffsets(_ observer: @escaping ValueUpdate<[CGPoint]>) {

        let (offsetUpdate, layerUpdate) = combineLatestUpdate(mapUpdate(observer, ParallaxViewModelImp.merge(self)))

        self.contentOffset.subscribe(offsetUpdate)
        self.model.observeLayers(layerUpdate)
    }

    func merge(_ offset: CGPoint, _ layers: [ParallaxLayer]) -> [CGPoint] {

        layers.map { layer in CGPoint(x: offset.x / layer.distance, y: offset.y / layer.distance) }
    }

    private func mapLayers(_ layers: [ParallaxLayer]) -> [UIImage] {

        layers.map { layer in layer.image }
    }
}

