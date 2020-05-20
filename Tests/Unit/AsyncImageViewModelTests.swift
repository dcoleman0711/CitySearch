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
        let viewModel = given.imageViewModelIsCreated(model: model)
        let observer = given.imageObserver()
        let image = given.image()
        given.model(model, updatedImageTo: image)

        when.observeImage(viewModel, observer)

        then.observer(observer, isNotifiedWith: image)
    }

    func testObserveImagesUpdate() {

        let model = given.imageModel()
        let viewModel = given.imageViewModelIsCreated(model: model)
        let image = given.image()
        let observer = given.imageObserver()
        given.observeImage(viewModel, observer)

        when.model(model, updatedImageTo: image)

        then.observer(observer, isNotifiedWith: image)
    }

    func testObserveImagesImmediatelyPublishNilIfNot() {

        let model = given.imageModel()
        let viewModel = given.imageViewModelIsCreated(model: model)
        let observer = given.imageObserver()

        when.observeImage(viewModel, observer)

        then.observerIsNotifiedWithNil(observer)
    }
}

class AsyncImageViewModelSteps {

    private let resultViewModelFactory = AsyncImageViewModelFactoryMock()

    private var valuePassedToObserver: UIImage??
    private var modelObserver: ValueUpdate<UIImage>?

    private var updatedImage: UIImage?

    func imageObserver() -> ValueUpdate<UIImage?> {

        { (value) in

            self.valuePassedToObserver = value
        }
    }

    func imageViewModelIsCreated(model: AsyncImageModelMock) -> AsyncImageViewModelImp {

        AsyncImageViewModelImp(model: model)
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

    func observeImage(_ viewModel: AsyncImageViewModelImp, _ observer: @escaping ValueUpdate<UIImage?>) {

        viewModel.observeImage(observer)
    }

    func observer(_ observer: ValueUpdate<UIImage?>, isNotifiedWith expectedValue: UIImage) {

        XCTAssertTrue(valuePassedToObserver??.isSameImageAs(expectedValue) ?? false, "Observer was not notified of correct results")
    }

    func observerIsNotifiedWithNil(_ observer: ValueUpdate<UIImage?>) {

        guard let image = valuePassedToObserver else {
            XCTFail("Observer was not notified")
            return
        }

        XCTAssertTrue(image == nil, "Observer was not notified with nil")
    }
}