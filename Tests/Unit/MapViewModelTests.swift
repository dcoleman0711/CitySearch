//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit
import CoreLocation

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

    func testMarkerImage() {

        let markerImage = given.markerImage()
        let imageObserver = given.imageObserver()
        let viewModel = given.viewModelIsCreated()

        when.observer(imageObserver, observesMarkerImageIn: viewModel)

        then.observer(imageObserver, receivedValue: markerImage)
    }

    func testMarkerSize() {

        let markerSize = given.markerSize()
        let frameObserver = given.frameObserver()
        let model = given.model()
        let viewModel = given.viewModelIsCreated(model: model)

        when.observer(frameObserver, observesMarkerFrameIn: viewModel)

        then.observer(frameObserver, receivedValueWithSize: markerSize)
    }

    func testMarkerPosition() {

        let geoCoordinates = given.geoCoordinates()
        let markerPosition = given.markerPosition(for: geoCoordinates)
        let model = given.model()
        given.model(model, updatedGeoCoordinatesTo: geoCoordinates)
        let frameObserver = given.frameObserver()
        let viewModel = given.viewModelIsCreated(model: model)

        when.observer(frameObserver, observesMarkerFrameIn: viewModel)

        then.observer(frameObserver, receivedValueWithPosition: markerPosition)
    }
}

class MapViewModelSteps {

    private var observedImage: UIImage?
    private var observedFrame: CGRect?

    private var geoCoordinatesObserver: ValueUpdate<CLLocationCoordinate2D>?

    private var updatedGeoCoordinates = CLLocationCoordinate2D()

    func imageObserver() -> ValueUpdate<UIImage> {

        { image in

            self.observedImage = image
        }
    }

    func model() -> MapModelMock {

        let model = MapModelMock()

        model.observeGeoCoordinatesImp = { observer in

            self.geoCoordinatesObserver = observer
            observer(self.updatedGeoCoordinates)
        }

        return model
    }

    func backgroundImage() -> UIImage {

        ImageLoader.loadImage(name: "MapBackground.jpg")!
    }

    func markerImage() -> UIImage {

        ImageLoader.loadImage(name: "MapMarker")!
    }

    func markerSize() -> CGSize {

        CGSize(width: 16.0, height: 16.0)
    }

    func frameObserver() -> ValueUpdate<CGRect> {

        { frame in

            self.observedFrame = frame
        }
    }

    func geoCoordinates() -> CLLocationCoordinate2D {

        CLLocationCoordinate2D(latitude: 20, longitude: 130)
    }

    func markerPosition(for geoCoordinates: CLLocationCoordinate2D) -> CGPoint {

        CGPoint(x: fmod((geoCoordinates.longitude / 360.0) + 0.5, 1.0), y: 1.0 - (geoCoordinates.latitude + 90.0) / 180.0)
    }

    func viewModelIsCreated(model: MapModelMock = MapModelMock()) -> MapViewModelImp {

        MapViewModelImp(model: model)
    }

    func observer(_ imageObserver: @escaping ValueUpdate<UIImage>, observesBackgroundIn viewModel: MapViewModelImp) {

        viewModel.observeBackgroundImage(imageObserver)
    }

    func observer(_ imageObserver: @escaping ValueUpdate<UIImage>, observesMarkerImageIn viewModel: MapViewModelImp) {

        viewModel.observeMarkerImage(imageObserver)
    }

    func observer(_ frameObserver: @escaping ValueUpdate<CGRect>, observesMarkerFrameIn viewModel: MapViewModelImp) {

        viewModel.observeMarkerFrame(frameObserver)
    }

    func model(_ model: MapModelMock, updatedGeoCoordinatesTo geoCoordinates: CLLocationCoordinate2D) {

        self.updatedGeoCoordinates = geoCoordinates
        geoCoordinatesObserver?(geoCoordinates)
    }

    func observer(_ observer: @escaping ValueUpdate<UIImage>, receivedValue backgroundImage: UIImage) {

        XCTAssertTrue(observedImage?.isSameImageAs(backgroundImage) ?? false, "Marker Image Observer did not receive correct image")
    }

    func observer(_ frameObserver: ValueUpdate<CGRect>, receivedValueWithSize expectedSize: CGSize) {

        XCTAssertTrue(observedFrame?.size == expectedSize, "Marker Image Observer did not receive correct size")
    }

    func observer(_ frameObserver: ValueUpdate<CGRect>, receivedValueWithPosition expectedPosition: CGPoint) {

        XCTAssertTrue(observedFrame?.origin == expectedPosition, "Marker Image Observer did not receive correct position")
    }
}
