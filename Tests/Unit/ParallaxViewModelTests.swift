//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class ParallaxViewModelTests: XCTestCase {

    var steps: ParallaxViewModelSteps!

    var given: ParallaxViewModelSteps { steps }
    var when: ParallaxViewModelSteps { steps }
    var then: ParallaxViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ParallaxViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testOffsets() {

        let model = given.model()
        let parallaxLayers = given.parallaxLayers()
        given.model(model, publishes: parallaxLayers)
        let viewModel = given.detailsViewModel(model: model)
        let offset = given.offset()
        let expectedOffsets = given.expectedOffsets(for: parallaxLayers, andOffset: offset)
        let offsetsObserver = given.offsetsObserver()
        given.offsetsObserver(offsetsObserver, isSubscribedTo: viewModel)

        when.detailsViewModel(viewModel, offsetIsUpdatedTo: offset)

        then.offsetsObserver(offsetsObserver, isUpdatedWith: expectedOffsets)
    }

    func testImages() {

        let model = given.model()
        let parallaxLayers = given.parallaxLayers()
        let viewModel = given.detailsViewModel(model: model)
        let images = given.images(for: parallaxLayers)
        let imagesObserver = given.imagesObserver()
        given.imagesObserver(imagesObserver, isSubscribedTo: viewModel)

        when.model(model, publishes: parallaxLayers)

        then.imagesObserver(imagesObserver, isUpdatedWith: images)
    }
}

class ParallaxViewModelSteps {

    private var layersObserver: ValueUpdate<[ParallaxLayer]>?

    private var updatedParallaxLayers: [ParallaxLayer]?

    private var updatedOffsets: [CGPoint]?
    private var observedImages: [UIImage]?

    func model() -> ParallaxModelMock {

        let model = ParallaxModelMock()

        model.observeLayersImp = { observer in

            self.layersObserver = observer
            if let layers = self.updatedParallaxLayers { observer(layers) }
        }

        return model
    }

    func parallaxLayers() -> [ParallaxLayer] {

        (0..<5).map { index in ParallaxLayer(distance: 10.0 / CGFloat(index + 1), image: UIImageMock()) }
    }

    func images(for layers: [ParallaxLayer]) -> [UIImage] {

        layers.map { layer in layer.image }
    }

    func offsetsObserver() -> ValueUpdate<[CGPoint]> {

        { offsets in

            self.updatedOffsets = offsets
        }
    }

    func imagesObserver() -> ValueUpdate<[UIImage]> {

        { images in

            self.observedImages = images
        }
    }

    func model(_ model: ParallaxModelMock, publishes parallaxLayers: [ParallaxLayer]) {

        self.updatedParallaxLayers = parallaxLayers
        layersObserver?(parallaxLayers)
    }

    func detailsViewModel(model: ParallaxModelMock) -> ParallaxViewModelImp {

        ParallaxViewModelImp(model: model)
    }

    func offset() -> CGPoint {

        CGPoint(x: 80.0, y: 0.0)
    }

    func expectedOffsets(for layers: [ParallaxLayer], andOffset offset: CGPoint) -> [CGPoint] {

        layers.map { layer in CGPoint(x: -offset.x / layer.distance, y: -offset.y / layer.distance) }
    }

    func detailsViewModel(_ viewModel: ParallaxViewModelImp, offsetIsUpdatedTo offset: CGPoint) {

        let observer = viewModel.subscribeToContentOffset()
        observer(offset)
    }

    func offsetsObserver(_ offsetsObserver: @escaping ValueUpdate<[CGPoint]>, isSubscribedTo viewModel: ParallaxViewModelImp) {

        viewModel.observeOffsets(offsetsObserver)
    }

    func imagesObserver(_ imagesObserver: @escaping ValueUpdate<[UIImage]>, isSubscribedTo viewModel: ParallaxViewModelImp) {

        viewModel.observeImages(imagesObserver)
    }

    func offsetsObserver(_ offsetsObserver: ValueUpdate<[CGPoint]>, isUpdatedWith expectedOffsets: [CGPoint]) {

        XCTAssertEqual(updatedOffsets, expectedOffsets, "Offsets were not updated correctly")
    }

    func imagesObserver(_ imagesObserver: ValueUpdate<[UIImage]>, isUpdatedWith expectedImages: [UIImage]) {

        XCTAssertTrue(observedImages?.elementsEqual(expectedImages, by: UIImage.compareImages) ?? false, "Images were not updated correctly")
    }
}