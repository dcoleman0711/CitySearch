//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class MapViewTests: XCTestCase {

    var steps: MapViewSteps!

    var given: MapViewSteps { steps }
    var when: MapViewSteps { steps }
    var then: MapViewSteps { steps }

    override func setUp() {

        super.setUp()

        steps = MapViewSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testBackgroundImageViewData() {

        let viewModel = given.viewModel()
        let backgroundImageView = given.backgroundImageView()
        let binder = given.binder()

        let mapView = when.mapViewIsCreated(backgroundImageView: backgroundImageView, viewModel: viewModel, binder: binder)

        then.backgroundImageView(backgroundImageView, isBoundTo: viewModel)
    }

    func testBackgroundImageViewIsView() {

        let backgroundImageView = given.backgroundImageView()

        let mapView = when.mapViewIsCreated(backgroundImageView: backgroundImageView)

        then.backgroundImageView(backgroundImageView, isViewOf: mapView)
    }

    func testMarkerImageViewImage() {

        let viewModel = given.viewModel()
        let markerImageView = given.markerImageView()
        let binder = given.binder()

        let mapView = when.mapViewIsCreated(markerImageView: markerImageView, viewModel: viewModel, binder: binder)

        then.markerImageView(markerImageView, isBoundTo: viewModel)
    }

    func testMarkerImageViewAutoResizeMaskDisabled() {

        let markerImageView = given.markerImageView()

        let mapView = when.mapViewIsCreated(markerImageView: markerImageView)

        then.autoResizeMaskIsDisabled(for: markerImageView)
    }

    func testMarkerImageViewFrame() {

        let frame = given.frame()
        let viewModel = given.viewModel()
        given.viewModel(viewModel, hasUpdatedFrameTo: frame)
        let markerImageView = given.markerImageView()
        let mapView = given.mapViewIsCreated(markerImageView: markerImageView, viewModel: viewModel)

        when.mapViewIsLayedOut(mapView)

        then.markerImageView(markerImageView, bottomLeftIsPercentage: frame, inView: mapView)
    }
}

class MapViewSteps {

    private var boundImageView: UIImageView?

    private var backgroundImageObserver: ValueUpdate<UIImage>?

    private var imageViewBoundToBackground: UIImageView?
    private var imageViewBoundToMarker: UIImageView?

    private var updatedFrame = CGRect.zero

    private var markerFrameObserver: ValueUpdate<CGRect>?

    func binder() -> ViewBinderMock {

        let binder = ViewBinderMock()

        binder.bindImageImp = { imageView in

            { (image) in

                self.boundImageView = imageView
            }
        }

        return binder
    }

    func backgroundImageView() -> UIImageView {

        UIImageView()
    }

    func markerImageView() -> UIImageView {

        UIImageView()
    }

    func markerSize() -> CGSize {

        CGSize(width: 16.0, height: 16.0)
    }

    func markerPosition() -> CGPoint {

        CGPoint(x: 64.0, y: 128.0)
    }

    func frame() -> CGRect {

        CGRect(x: 0.2, y: 0.4, width: 16.0, height: 16.0)
    }

    func viewModel() -> MapViewModelMock {

        let viewModel = MapViewModelMock()
        
        viewModel.observeBackgroundImageImp = { observer in

            observer(UIImageMock())
            self.imageViewBoundToBackground = self.boundImageView
        }

        viewModel.observeMarkerImageImp = { observer in

            observer(UIImageMock())
            self.imageViewBoundToMarker = self.boundImageView
        }

        viewModel.observeMarkerFrameImp = { observer in

            self.markerFrameObserver = observer
            observer(self.updatedFrame)
        }

        return viewModel
    }

    func viewModel(_ viewModel: MapViewModelMock, hasUpdatedFrameTo frame: CGRect) {

        self.updatedFrame = frame
        markerFrameObserver?(frame)
    }

    func mapViewIsCreated(backgroundImageView: UIImageView = UIImageView(), markerImageView: UIImageView = UIImageView(), viewModel: MapViewModelMock = MapViewModelMock(), binder: ViewBinderMock = ViewBinderMock()) -> MapViewImp {

        MapViewImp(backgroundImageView: backgroundImageView, markerImageView: markerImageView, viewModel: viewModel, binder: binder)
    }

    func backgroundImageView(_ backgroundImageView: UIImageView, isViewOf mapView: MapViewImp) {

        XCTAssertEqual(backgroundImageView, mapView.view, "MapView's view is not the background image")
    }

    func backgroundImageView(_ backgroundImageView: UIImageView, isBoundTo viewModel: MapViewModelMock) {

        XCTAssertEqual(imageViewBoundToBackground, backgroundImageView, "Background Image View was not bound to view model")
    }

    func markerImageView(_ markerImageView: UIImageView, isBoundTo viewModel: MapViewModelMock) {

        XCTAssertEqual(imageViewBoundToMarker, markerImageView, "Marker Image View was not bound to view model")
    }

    func autoResizeMaskIsDisabled(for view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresizing mask is not disabled")
    }

    func mapViewIsLayedOut(_ mapView: MapViewImp) {

        mapView.view.bounds = CGRect(origin: .zero, size: CGSize(width: 256.0, height: 128.0))
        mapView.view.setNeedsLayout()
        mapView.view.layoutIfNeeded()
    }

    func markerImageView(_ markerImageView: UIImageView, bottomLeftIsPercentage frame: CGRect, inView mapView: MapViewImp) {

        let markerFrame = markerImageView.frame
        let frameIsCorrect = markerFrame.minX == floor(frame.origin.x * mapView.view.frame.size.width) &&
                markerFrame.maxY == floor(frame.origin.y * mapView.view.frame.size.height)

        XCTAssertTrue(frameIsCorrect, "Marker frame is not positioned correctly")
    }
}