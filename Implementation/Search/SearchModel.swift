//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchModel {
}

class SearchModelImp : SearchModel {

    private let parallaxModel: ParallaxModel
    private let searchResultsModel: SearchResultsModel

    init(parallaxModel: ParallaxModel, searchResultsModel: SearchResultsModel) {

        self.parallaxModel = parallaxModel
        self.searchResultsModel = searchResultsModel

        let layers = [ParallaxLayer(distance: 4.0, image: ImageLoader.loadImage(name: "Parallax2.jpg")!),
                      ParallaxLayer(distance: 2.0, image: ImageLoader.loadImage(name: "Parallax1.png")!)]

        parallaxModel.setLayers(layers)
    }
}
