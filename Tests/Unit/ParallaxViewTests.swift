//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class ParallaxViewTests: XCTestCase {

    var steps: ParallaxViewSteps!

    var given: ParallaxViewSteps { steps }
    var when: ParallaxViewSteps { steps }
    var then: ParallaxViewSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ParallaxViewSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testImageViewsImages() {

        let viewModel = given.viewModel()
        let images = given.images()
        let parallaxView = given.parallaxViewIsCreated(viewModel: viewModel)

        when.viewModel(viewModel, publishesImages: images)

        then.parallaxView(parallaxView, hasArrayImageViewsWith: images)
    }

    func testImageViewsAutoresizeMasks() {

        let viewModel = given.viewModel()
        let images = given.images()
        let parallaxView = given.parallaxViewIsCreated(viewModel: viewModel)

        when.viewModel(viewModel, publishesImages: images)

        then.allSubviewsHaveAutoresizeMasksDisabledIn(parallaxView)
    }

    func testImageViewsConstraints() {

        let viewModel = given.viewModel()
        let images = given.images()
        let parallaxView = given.parallaxViewIsCreated(viewModel: viewModel)

        when.viewModel(viewModel, publishesImages: images)

        then.parallaxView(parallaxView, allImageViewsAreConstrainedToTopAndBottomWithCorrectAspectRatiosFor: images)
    }

    func testImageViewsOffsets() {

        let viewModel = given.viewModel()
        let images = given.images()
        let offsets = given.offsets(for: images)
        let parallaxView = given.parallaxViewIsCreated(viewModel: viewModel)
        given.viewModel(viewModel, publishesImages: images)

        when.viewModel(viewModel, publishesOffsets: offsets)

        then.parallaxView(parallaxView, imageViewsHaveConstraintsForOffsets: offsets)
    }
}

class ParallaxViewSteps {

    private var boundImages: [UIImageView: UIImage] = [:]

    private var imagesObserver: ValueUpdate<[UIImage]>?
    private var offsetsObserver: ValueUpdate<[CGPoint]>?

    func images() -> [UIImage] {

        (0..<5).map { _ in

            let imageView = UIImageMock()
            imageView.sizeMock = CGSize(width: 125.0, height: 234.0)
            return imageView
        }
    }

    func offsets(for images: [UIImage]) -> [CGPoint] {

        (0..<images.count).map { index in CGPoint(x: CGFloat(index) * 100.0, y: 0.0) }
    }

    func viewModel() -> ParallaxViewModelMock {

        let viewModel = ParallaxViewModelMock()

        viewModel.observeImagesImp = { observer in

            self.imagesObserver = observer
        }

        viewModel.observeOffsetsImp = { observer in

            self.offsetsObserver = observer
        }

        return viewModel
    }

    func parallaxViewIsCreated(viewModel: ParallaxViewModelMock) -> ParallaxViewImp {

        ParallaxViewImp(viewModel: viewModel)
    }

    func viewModel(_ viewModel: ParallaxViewModelMock, publishesImages images: [UIImage]) {

        self.imagesObserver?(images)
    }

    func viewModel(_ viewModel: ParallaxViewModelMock, publishesOffsets offsets: [CGPoint]) {

        self.offsetsObserver?(offsets)
    }

    func allSubviewsHaveAutoresizeMasksDisabledIn(_ parallaxView: ParallaxViewImp) {

        for view in parallaxView.view.subviews {

            XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresize mask is not disabled")
        }
    }

    func parallaxView(_ parallaxView: ParallaxView, hasArrayImageViewsWith expectedImages: [UIImage]) {

        guard let imageViews = parallaxView.view.subviews as? [UIImageView] else {
            XCTFail("Parallax view should only have UIImageView subviews")
            return
        }

        let images = imageViews.map { view in view.image }

        XCTAssertTrue(images.elementsEqual(expectedImages, by: UIImage.compareImages), "Image views do not have the correct images")
    }

    func parallaxView(_ parallaxView: ParallaxViewImp, allImageViewsAreConstrainedToTopAndBottomWithCorrectAspectRatiosFor images: [UIImage]) {

        guard let imageViews = parallaxView.view.subviews as? [UIImageView] else {
            XCTFail("Parallax view should only have UIImageView subviews")
            return
        }

        let imagesAndImageViews = zip(images, imageViews)

        for (image, imageView) in imagesAndImageViews {

            let expectedConstraints = [imageView.topAnchor.constraint(equalTo: parallaxView.view.topAnchor),
                                       imageView.bottomAnchor.constraint(equalTo: parallaxView.view.bottomAnchor),
                                       imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image.size.width / image.size.height)]

            ViewConstraintValidator.validateThatView(parallaxView.view, hasConstraints: expectedConstraints, message: "Image views do not have correct constraints")
        }
    }

    func parallaxView(_ parallaxView: ParallaxViewImp, imageViewsHaveConstraintsForOffsets offsets: [CGPoint]) {

        guard let imageViews = parallaxView.view.subviews as? [UIImageView] else {
            XCTFail("Parallax view should only have UIImageView subviews")
            return
        }

        let offsetsAndImageViews = zip(offsets, imageViews)

        for (offset, imageView) in offsetsAndImageViews {

            let expectedConstraint = imageView.leftAnchor.constraint(equalTo: parallaxView.view.leftAnchor, constant: offset.x)

            ViewConstraintValidator.validateThatView(parallaxView.view, hasConstraints: [expectedConstraint], message: "Image views do not have correct constraints for offsets")
        }
    }
}