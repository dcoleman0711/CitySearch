//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit
import Combine

class ImageServiceMock: ImageService {

    var fetchImageImp: (_ url: URL) -> ImagePublisher = { url in Future<UIImage, Error>({ promise in }).eraseToAnyPublisher() }
    func fetchImage(_ url: URL) -> ImagePublisher {

        fetchImageImp(url)
    }
}
