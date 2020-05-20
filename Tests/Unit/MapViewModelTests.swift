//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class MapViewModelTests: XCTestCase {

    var steps: MapViewModelSteps!

    var given: MapViewModelSteps { steps }
    var when: MapViewModelSteps { steps }
    var then: MapViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = MapViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testBackground() {

        let backgroundImage = given.backgroundImage()
        let imageObserver = given.imageObserver()
        let viewModel = given.viewModelIsCreated()

        when.observer(imageObserver, observesBackgroundIn: viewModel)

        then.observer(imageObserver, receivedValue: backgroundImage)
    }
}

class MapViewModelSteps {

    private var observedImage: UIImage?

    func imageObserver() -> ValueUpdate<UIImage> {

        { image in

            self.observedImage = image
        }
    }

    func observer(_ imageObserver: @escaping ValueUpdate<UIImage>, observesBackgroundIn viewModel: MapViewModelImp) {

        viewModel.observeBackgroundImage(imageObserver)
    }

    func model() -> MapModelMock {

        let model = MapModelMock()

        return model
    }

    func backgroundImage() -> UIImage {

        ImageLoader.loadImage(name: "MapBackground.jpg")!
    }

    func viewModelIsCreated(model: MapModelMock = MapModelMock()) -> MapViewModelImp {

        MapViewModelImp(model: model)
    }

    func observer(_ observer: @escaping ValueUpdate<UIImage>, receivedValue backgroundImage: UIImage) {

        XCTAssertTrue(observedImage?.isSameImageAs(backgroundImage) ?? false, "Background Observer did not receive correct image")
    }
}