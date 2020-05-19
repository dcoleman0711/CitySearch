//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol ImageCarouselModel {

    func observeResultsModels(_ observer: @escaping ValueUpdate<[AsyncImageModel]>)

    func setResults(_ results: [URL])
}

class ImageCarouselModelImp : ImageCarouselModel {

    func observeResultsModels(_ observer: @escaping ValueUpdate<[AsyncImageModel]>) {

    }

    func setResults(_ results: [URL]) {

    }
}