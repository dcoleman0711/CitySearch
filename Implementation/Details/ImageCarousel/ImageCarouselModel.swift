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

    private let modelFactory: AsyncImageModelFactory
    private let imageModels: Observable<[AsyncImageModel]>

    convenience init() {

        self.init(modelFactory: AsyncImageModelFactoryImp(), imageModels: Observable<[AsyncImageModel]>([]))
    }

    init(modelFactory: AsyncImageModelFactory, imageModels: Observable<[AsyncImageModel]>) {

        self.modelFactory = modelFactory
        self.imageModels = imageModels
    }

    func observeResultsModels(_ observer: @escaping ValueUpdate<[AsyncImageModel]>) {

        imageModels.subscribe(observer, updateImmediately: true)
    }

    func setResults(_ results: [URL]) {

        imageModels.value = results.map({ url in self.modelFactory.imageModel(for: url) })
    }
}