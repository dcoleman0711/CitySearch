//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit
import Combine

protocol ImageService {

    typealias ImageFuture = Future<UIImage, Error>

    func fetchImage(_ url: URL) -> ImageFuture
}

class ImageServiceImp: ImageService {

    func fetchImage(_ url: URL) -> ImageFuture {

        ImageFuture({ promise in

        })
    }
}