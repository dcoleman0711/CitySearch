//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class AsyncImageModelFactoryMock: AsyncImageModelFactory {

    var imageModelImp: (_ url: URL) -> AsyncImageModel = { url in AsyncImageModelMock() }
    func imageModel(for url: URL) -> AsyncImageModel {

        imageModelImp(url)
    }
}
