//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit
import Combine

class AsyncImageModelTests: XCTestCase {

    var steps: AsyncImageModelSteps!

    var given: AsyncImageModelSteps { steps }
    var when: AsyncImageModelSteps { steps }
    var then: AsyncImageModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = AsyncImageModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testObserveImageImmediate() {

        let imageService = given.imageService()
        let imageURL = given.imageURL()
        let imageModel = given.imageModelIsCreated(imageURL: imageURL, imageService: imageService)
        let observer = given.resultsObserver()
        let image = given.image()
        given.imageService(imageService, returns: image, for: imageURL)

        when.observeSearchResults(imageModel, observer)

        then.observerIsNotified(observer, ofNewValue: image)
    }

    func testObserveImageUpdate() {

        let imageService = given.imageService()
        let imageURL = given.imageURL()
        let image = given.image()
        let imageModel = given.imageModelIsCreated(imageURL: imageURL, imageService: imageService)
        let observer = given.resultsObserver()
        given.observeSearchResults(imageModel, observer)

        when.imageService(imageService, returns: image, for: imageURL)

        then.observerIsNotified(observer, ofNewValue: image)
    }

    func testObserveImageFailure() {

        let imageService = given.imageService()
        let imageURL = given.imageURL()
        let missingImage = given.missingImage()
        let imageModel = given.imageModelIsCreated(imageURL: imageURL, imageService: imageService)
        let observer = given.resultsObserver()
        given.observeSearchResults(imageModel, observer)

        when.imageService(imageService, failsFor: imageURL)

        then.observerIsNotified(observer, ofNewValue: missingImage)
    }
}

class AsyncImageModelSteps {

    private var valuePassedToObserver: UIImage?

    private var listenerPassedToObservable: ValueUpdate<UIImage>?

    private var imagePromises: [URL: Future<UIImage, Error>.Promise] = [:]

    func imageService() -> ImageServiceMock {

        let imageService = ImageServiceMock()

        imageService.fetchImageImp = { requestURL in

            Future<UIImage, Error>({ promise in

                self.imagePromises[requestURL] = promise

            }).eraseToAnyPublisher()
        }

        return imageService
    }

    func imageURL() -> URL {

        URL(string: "https://")!
    }

    func image() -> UIImage {

        ImageLoader.loadImage(name: "TestImage.jpg")!
    }

    func missingImage() -> UIImage {

        ImageLoader.loadImage(name: "MissingImage.jpg")!
    }

    func resultsObserver() -> ValueUpdate<UIImage> {

        { (value) in

            self.valuePassedToObserver = value
        }
    }

    func imageService(_ imageService: ImageServiceMock, returns image: UIImage, for url: URL) {

        guard let promise = imagePromises[url] else { return }

        promise(.success(image))
    }

    func imageService(_ imageService: ImageServiceMock, failsFor url: URL) {

        guard let promise = imagePromises[url] else { return }

        promise(.failure(NSError(domain: "", code: 0)))
    }

    func imageModelIsCreated(imageURL: URL, imageService: ImageServiceMock) -> AsyncImageModelImp {

        AsyncImageModelImp(imageURL: imageURL, imageService: imageService)
    }

    func observeSearchResults(_ model: AsyncImageModelImp, _ observer: @escaping ValueUpdate<UIImage>) {

        model.observeImage(observer)
    }

    func observerIsNotified(_ observer: ValueUpdate<UIImage>, ofNewValue newValue: UIImage) {

        XCTAssertTrue(UIImage.compareImages(lhs: valuePassedToObserver, rhs: newValue), "Observer was not notified of correct results")
    }
}