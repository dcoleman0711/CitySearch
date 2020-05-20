//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit
import Combine

protocol AsyncImageModel: class {

    func observeImage(_ observer: @escaping ValueUpdate<UIImage>)
}

class AsyncImageModelImp : AsyncImageModel {

    private let imageResult: ImageService.ImagePublisher

    private var subscriber: Cancellable?

    init(imageURL: URL, imageService: ImageService) {

        self.imageResult = imageService.fetchImage(imageURL)
    }

    func observeImage(_ observer: @escaping ValueUpdate<UIImage>) {

        self.subscriber = imageResult.sink(receiveCompletion: { completion in

            switch completion {

            case .failure(let error):
                self.handleFail(error: error, observer)

            default:
                break
            }

        }, receiveValue: { image in

            self.handleSuccess(image: image, observer)
        })
    }

    private func handleSuccess(image: UIImage, _ observer: @escaping ValueUpdate<UIImage>) {

        observer(image)
        self.subscriber = nil
    }

    private func handleFail(error: Error, _ observer: @escaping ValueUpdate<UIImage>) {

        observer(AsyncImageModelImp.missingImage)
        self.subscriber = nil
    }

    static private var missingImage: UIImage {

        ImageLoader.loadImage(name: "MissingImage.jpg")!
    }
}