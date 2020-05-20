//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol ShimmeringLoaderView where Self: UIView {

    func startAnimating()
    func stopAnimating()
}

class ShimmeringLoaderViewImp: UIView, ShimmeringLoaderView {

    private var displayLink: CADisplayLink!

    private var startTime: CFTimeInterval?

    private static let darkest: CGFloat = 0.2
    private static let lightest: CGFloat = 0.6

    private let displayLinkFactory: CADisplayLinkFactory

    override convenience init(frame: CGRect) {

        self.init(displayLinkFactory: CADisplayLinkFactoryImp())
    }

    init(displayLinkFactory: CADisplayLinkFactory) {

        self.displayLinkFactory = displayLinkFactory

        super.init(frame: .zero)

        stopAnimating()
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder!")
    }

    func startAnimating() {

        self.alpha = 1.0

        displayLink = displayLinkFactory.displayLink(target: self, selector: #selector(tick))
        displayLink.add(to: .main, forMode: .common)
    }

    func stopAnimating() {

        displayLink?.invalidate()
        self.alpha = 0.0
    }

    @objc private func tick() {

        guard let startTime = self.startTime else {
            self.startTime = displayLink.timestamp
            return
        }

        let interval = CGFloat(displayLink.timestamp - startTime)

        let factor = sin(4.0 * interval) * 0.5 + 0.5

        let grayVal = ShimmeringLoaderViewImp.darkest + (ShimmeringLoaderViewImp.lightest - ShimmeringLoaderViewImp.darkest) * factor

        self.backgroundColor = UIColor(white: grayVal, alpha: 1.0)
    }
}
