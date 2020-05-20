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

    func testImageViewData() {

        let viewModel = given.viewModel()
        let imageView = given.imageView()
        let binder = given.binder()

        let mapView = when.mapViewIsCreated(backgroundImageView: imageView, viewModel: viewModel, binder: binder)

        then.backgroundImageView(imageView, isBoundTo: viewModel)
    }

    func testImageViewIsView() {

        let imageView = given.imageView()

        let mapView = when.mapViewIsCreated(backgroundImageView: imageView)

        then.backgroundImageView(imageView, isViewOf: mapView)
    }
}

class MapViewSteps {

    private var boundImageView: UIImageView?

    private var backgroundImageObserver: ValueUpdate<UIImage>?

    private var imageViewBoundToBackground: UIImageView?

    func binder() -> ViewBinderMock {

        let binder = ViewBinderMock()

        binder.bindImageImp = { imageView in

            { (image) in

                self.boundImageView = imageView
            }
        }

        return binder
    }

    func imageView() -> UIImageView {

        UIImageView()
    }

    func viewModel() -> MapViewModelMock {

        let viewModel = MapViewModelMock()
        
        viewModel.observeBackgroundImageImp = { observer in

            observer(UIImageMock())
            self.imageViewBoundToBackground = self.boundImageView
        }

        return viewModel
    }

    func mapViewIsCreated(backgroundImageView: UIImageView = UIImageView(), viewModel: MapViewModelMock = MapViewModelMock(), binder: ViewBinderMock = ViewBinderMock()) -> MapView {

        MapViewImp(backgroundImageView: backgroundImageView, viewModel: viewModel, binder: binder)
    }

    func backgroundImageView(_ backgroundImageView: UIImageView, isViewOf mapView: MapView) {

        XCTAssertEqual(backgroundImageView, mapView.view, "MapView's view is not the background image")
    }

    func backgroundImageView(_ backgroundImageView: UIImageView, isBoundTo viewModel: MapViewModelMock) {

        XCTAssertEqual(imageViewBoundToBackground, backgroundImageView, "Background Image View was not bound to view model")
    }
}