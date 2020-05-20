//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class ParallaxModelTests: XCTestCase {

    var steps: ParallaxModelSteps!

    var given: ParallaxModelSteps { steps }
    var when: ParallaxModelSteps { steps }
    var then: ParallaxModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ParallaxModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testLayers() {

        let model = given.model()
        let parallaxLayers = given.parallaxLayers()
        let layersObserver = given.layersObserver()
        given.layersObserver(layersObserver, isSubscribedTo: model)

        when.model(model, setLayers: parallaxLayers)

        then.model(model, publishes: parallaxLayers)
    }
}

class ParallaxModelSteps {

    private var updatedLayers: [ParallaxLayer]?

    func model() -> ParallaxModelImp {

        ParallaxModelImp()
    }

    func parallaxLayers() -> [ParallaxLayer] {

        (0..<5).map { index in ParallaxLayer(distance: 10.0 / CGFloat(index + 1), image: UIImageMock()) }
    }

    func layersObserver() -> ValueUpdate<[ParallaxLayer]> {

        { layers in

            self.updatedLayers = layers
        }
    }

    func layersObserver(_ layersObserver: @escaping ValueUpdate<[ParallaxLayer]>, isSubscribedTo model: ParallaxModelImp) {

        model.observeLayers(layersObserver)
    }

    func model(_ model: ParallaxModelImp, setLayers layers: [ParallaxLayer]) {

        model.setLayers(layers)
    }

    func model(_ model: ParallaxModelImp, publishes expectedLayers: [ParallaxLayer]) {

        XCTAssertEqual(updatedLayers, expectedLayers, "Model did not publish correct layers")
    }
}