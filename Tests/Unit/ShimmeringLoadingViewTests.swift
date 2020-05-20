//
//  Created by Daniel Coleman on 5/20/20.
//  Copyright © 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class ShimmeringLoadingViewTests: XCTestCase {

    var steps: ShimmeringLoadingViewSteps!

    var given: ShimmeringLoadingViewSteps { steps }
    var when: ShimmeringLoadingViewSteps { steps }
    var then: ShimmeringLoadingViewSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ShimmeringLoadingViewSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testStartAnimatingDisplayLink() {

        let displayLinkFactory = given.displayLinkFactory()
        let shimmerView = given.shimmerView(displayLinkFactory: displayLinkFactory)

        when.shimmerViewStartAnimating(shimmerView)

        then.displayLinkWasAdded()
    }

    func testStartAnimatingDisplayAlpha() {

        let displayLinkFactory = given.displayLinkFactory()
        let shimmerView = given.shimmerView(displayLinkFactory: displayLinkFactory)

        when.shimmerViewStartAnimating(shimmerView)

        then.shimmerView(shimmerView, alphaIs: 1.0)
    }

    func testStopAnimatingDisplayLink() {

        let displayLinkFactory = given.displayLinkFactory()
        let shimmerView = given.shimmerView(displayLinkFactory: displayLinkFactory)
        given.shimmerViewStartAnimating(shimmerView)

        when.shimmerViewStopAnimating(shimmerView)

        then.displayLinkWasInvalidated()
    }

    func testStopAnimatingDisplayAlpha() {

        let displayLinkFactory = given.displayLinkFactory()
        let shimmerView = given.shimmerView(displayLinkFactory: displayLinkFactory)
        given.shimmerViewStartAnimating(shimmerView)

        when.shimmerViewStopAnimating(shimmerView)

        then.shimmerView(shimmerView, alphaIs: 0.0)
    }

    func testTick() {

        let displayLinkFactory = given.displayLinkFactory()
        let shimmerView = given.shimmerView(displayLinkFactory: displayLinkFactory)
        given.shimmerViewStartAnimating(shimmerView)
        let timestamps = given.timestamps()
        let backgroundColors = given.backgroundColors(for: timestamps)

        when.displayLinkTicks(at: timestamps, for: shimmerView)

        then.shimmerView(shimmerView, backgroundColorsWere: backgroundColors)
    }
}

class ShimmeringLoadingViewSteps {

    private var displayLinkTarget: Any?
    private var displayLinkSelector: Selector?
    private var displayLink: CADisplayLinkMock?

    private var runLoop: RunLoop?
    private var mode: RunLoop.Mode?

    private var backgroundColors: [UIColor?] = []

    func displayLinkFactory() -> CADisplayLinkFactory {

        let displayLinkFactory = CADisplayLinkFactoryMock()

        displayLinkFactory.displayLinkImp = { target, selector in

            self.displayLinkTarget = target
            self.displayLinkSelector = selector

            let displayLink = CADisplayLinkMock()

            displayLink.addToRunLoopImp = { runLoop, mode in

                self.runLoop = runLoop
                self.mode = mode
            }

            displayLink.invalidateImp = {

                self.runLoop = nil
                self.mode = nil
            }

            self.displayLink = displayLink

            return displayLink
        }

        return displayLinkFactory
    }

    func timestamps() -> [CFTimeInterval] {

        (0..<60).map { index in CFTimeInterval(index) / 15.0 }
    }

    func backgroundColors(for timestamps: [CFTimeInterval]) -> [UIColor] {

        let intervals = timestamps.map { interval in interval - timestamps[0] }

        return intervals.map { interval in

            let factor: CGFloat = CGFloat(sin(4.0 * interval)) * 0.5 + 0.5
            let grayVal: CGFloat = 0.2 + (0.6 - 0.2) * factor
            return UIColor(white: grayVal, alpha: 1.0)
        }
    }

    func shimmerView(displayLinkFactory: CADisplayLinkFactory) -> ShimmeringLoaderViewImp {

        ShimmeringLoaderViewImp(displayLinkFactory: displayLinkFactory)
    }

    func shimmerViewStartAnimating(_ shimmerView: ShimmeringLoaderViewImp) {

        shimmerView.startAnimating()
    }

    func shimmerViewStopAnimating(_ shimmerView: ShimmeringLoaderViewImp) {

        shimmerView.stopAnimating()
    }

    func displayLinkTicks(at timestamps: [CFTimeInterval], for shimmerView: ShimmeringLoaderViewImp) {

        guard let displayLink = self.displayLink, let target = displayLinkTarget, let selector = displayLinkSelector else { return }

        var firstDiscarded = false
        for timestamp in timestamps {

            displayLink.timestampMock = timestamp
            displayLink.targetTimestampMock = timestamp

            (target as? NSObject)?.perform(selector)

            if firstDiscarded {
                self.backgroundColors.append(shimmerView.backgroundColor)
            }

            firstDiscarded = true
        }
    }

    func displayLinkWasAdded() {

        XCTAssertEqual(self.runLoop, RunLoop.main, "Display link was not added to main run loop")
        XCTAssertEqual(self.mode, RunLoop.Mode.common, "Display link was not added in common mode")
    }

    func shimmerView(_ shimmerView: ShimmeringLoaderViewImp, alphaIs expectedAlpha: CGFloat) {

        XCTAssertEqual(shimmerView.alpha, expectedAlpha, "Shimmer view alpha is not correct")
    }

    func displayLinkWasInvalidated() {

        XCTAssertTrue(self.runLoop == nil && self.mode == nil, "Display link was not invalidated")
    }

    func shimmerView(_ shimmerView: ShimmeringLoaderViewImp, backgroundColorsWere expectedBackgroundColors: [UIColor]) {

        guard let backgroundColors = self.backgroundColors as? [UIColor] else {
            XCTFail("Background color values were nil")
            return
        }

        XCTAssertEqual(backgroundColors, [UIColor](expectedBackgroundColors.suffix(from: 1)), "Background color was not animated correctly")
    }
}

class CADisplayLinkMock: CADisplayLink {

    var addToRunLoopImp: (_ runloop: RunLoop, _ mode: RunLoop.Mode) -> Void = { runloop, mode in }
    override func add(to runloop: RunLoop, forMode mode: RunLoop.Mode) {

        addToRunLoopImp(runloop, mode)
    }

    var invalidateImp: () -> Void = { }
    override func invalidate() {

        invalidateImp()
    }

    var timestampMock: CFTimeInterval = 0.0
    override var timestamp: CFTimeInterval {
        timestampMock
    }

    var targetTimestampMock: CFTimeInterval = 0.0
    override var targetTimestamp: CFTimeInterval {
        targetTimestampMock
    }
}