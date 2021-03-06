//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol AsyncImageModelFactory {

    func imageModel(for url: URL) -> AsyncImageModel
}

class AsyncImageModelFactoryImp: AsyncImageModelFactory {

    func imageModel(for url: URL) -> AsyncImageModel {

        AsyncImageModelImp(imageURL: url, imageService: ImageServiceImp())
    }
}
