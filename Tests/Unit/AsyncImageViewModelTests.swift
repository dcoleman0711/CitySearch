//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class AsyncImageViewModelTests: XCTestCase {

    var steps: AsyncImageViewModelSteps!

    var given: AsyncImageViewModelSteps { steps }
    var when: AsyncImageViewModelSteps { steps }
    var then: AsyncImageViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = AsyncImageViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testObserveImagesImmediate() {

        let model = given.imageModel()
        let resultsQueue = given.resultsQueue()
        let viewModel = given.imageViewModelIsCreated(model: model, resultsQueue: resultsQueue)
        let observer = given.imageObserver()
        let image = given.image()
        given.model(model, updatedImageTo: image)

        when.observeImage(viewModel, observer)

        then.observer(observer, isNotifiedWith: image, on: resultsQueue)
    }

    func testObserveImagesUpdate() {

        let model = given.imageModel()
        let resultsQueue = given.resultsQueue()
        let viewModel = given.imageViewModelIsCreated(model: model, resultsQueue: resultsQueue)
        let image = given.image()
        let observer = given.imageObserver()
        given.observeImage(viewModel, observer)

        when.model(model, updatedImageTo: image)

        then.observer(observer, isNotifiedWith: image, on: resultsQueue)
    }

    func testObserveImagesImmediatelyPublishNilIfNot() {

        let model = given.imageModel()
        let resultsQueue = given.resultsQueue()
        let viewModel = given.imageViewModelIsCreated(model: model, resultsQueue: resultsQueue)
        let observer = given.imageObserver()

        when.observeImage(viewModel, observer)

        then.observerIsNotifiedWithNil(observer, on: resultsQueue)
    }
}

class AsyncImageViewModelSteps {

    private let resultViewModelFactory = AsyncImageViewModelFactoryMock()

    private var valuePassedToObserver: UIImage??
    private var modelObserver: ValueUpdate<UIImage>?

    private var updatedImage: UIImage?

    private var isOnResultsQueue = false
    private var valuePassedOnResultsQueue = false

    func imageObserver() -> ValueUpdate<UIImage?> {

        { (value) in

            self.valuePassedToObserver = value
            self.valuePassedOnResultsQueue = self.isOnResultsQueue
        }
    }

    func imageViewModelIsCreated(model: AsyncImageModelMock, resultsQueue: DispatchQueueMock = DispatchQueueMock()) -> AsyncImageViewModelImp {

        AsyncImageViewModelImp(model: model, resultsQueue: resultsQueue)
    }

    func imageModel() -> AsyncImageModelMock {

        let model = AsyncImageModelMock()

        model.observeImageImp = { (observer) in

            self.modelObserver = observer

            if let image = self.updatedImage { observer(image) }
        }

        return model
    }

    func model(_ model: AsyncImageModelMock, updatedImageTo image: UIImage) {

        self.updatedImage = image
        modelObserver?(image)
    }

    func image() -> UIImage {

        ImageLoader.loadImage(name: "TestImage.jpg")!
    }

    func resultsQueue() -> DispatchQueueMock {

        let queue = DispatchQueueMock()

        queue.asyncImp = { work in

            self.isOnResultsQueue = true
            work()
            self.isOnResultsQueue = false
        }

        return queue
    }

    func observeImage(_ viewModel: AsyncImageViewModelImp, _ observer: @escaping ValueUpdate<UIImage?>) {

        viewModel.observeImage(observer)
    }

    func observer(_ observer: ValueUpdate<UIImage?>, isNotifiedWith expectedValue: UIImage, on resultsQueue: DispatchQueueMock) {

        XCTAssertTrue(valuePassedToObserver??.isSameImageAs(expectedValue) ?? false, "Observer was not notified of correct results")
        XCTAssertTrue(valuePassedOnResultsQueue, "Observer was not notified on results queue")
    }

    func observerIsNotifiedWithNil(_ observer: ValueUpdate<UIImage?>, on resultsQueue: DispatchQueueMock) {

        guard let image = valuePassedToObserver else {
            XCTFail("Observer was not notified")
            return
        }

        XCTAssertTrue(image == nil, "Observer was not notified with nil")
        XCTAssertTrue(valuePassedOnResultsQueue, "Observer was not notified on results queue")
    }
}