//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class ImageServiceMock: ImageService {

    var fetchImageImp: (_ url: URL) -> ImageFuture = { url in ImageFuture({ promise in }) }
    func fetchImage(_ url: URL) -> ImageFuture {

        fetchImageImp(url)
    }
}
