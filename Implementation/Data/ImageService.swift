//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit
import Combine

protocol ImageService {

    typealias ImagePublisher = AnyPublisher<UIImage, Error>

    func fetchImage(_ url: URL) -> ImagePublisher
}

class ImageServiceImp: ImageService {

    private let urlSession: URLSession

    convenience init() {

        self.init(urlSession: URLSession.shared)
    }

    init(urlSession: URLSession) {

        self.urlSession = urlSession
    }

    func fetchImage(_ url: URL) -> ImagePublisher {

        self.urlSession.dataTaskPublisher(for: url).tryMap({ data, response in try self.parseResponse(data) }).eraseToAnyPublisher()
    }

    private func parseResponse(_ data: Data) throws -> UIImage {

        guard let image = UIImage(data: data) else {
            throw URLError(.cannotParseResponse) as Error
        }

        return image
    }
}