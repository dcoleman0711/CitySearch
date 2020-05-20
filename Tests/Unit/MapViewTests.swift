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

        let viewModel = given.viewModel()
        let markerImageView = given.markerImageView()
        let binder = given.binder()

        let mapView = when.mapViewIsCreated(markerImageView: markerImageView, viewModel: viewModel, binder: binder)

        then.markerImageView(markerImageView, frameIsBoundTo: viewModel)
    }
}

class MapViewSteps {

    private var boundImageView: UIImageView?
    private var boundFrameView: UIView?

    private var backgroundImageObserver: ValueUpdate<UIImage>?

    private var imageViewBoundToBackground: UIImageView?
    private var imageViewBoundToMarker: UIImageView?
    private var viewBoundToMarkerFrame: UIView?

    func binder() -> ViewBinderMock {

        let binder = ViewBinderMock()

        binder.bindImageImp = { imageView in

            { (image) in

                self.boundImageView = imageView
            }
        }

        binder.bindFrameImp = { view in

            { (frame) in

                self.boundFrameView = view
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

            observer(.zero)
            self.viewBoundToMarkerFrame = self.boundFrameView
        }

        return viewModel
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

    func markerImageView(_ markerImageView: UIImageView, frameIsBoundTo: MapViewModelMock) {

        XCTAssertEqual(viewBoundToMarkerFrame, markerImageView, "Marker Image View was not bound to view model")
    }
}