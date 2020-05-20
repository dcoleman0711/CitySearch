//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class ShimmeringLoaderViewMock: UIView, ShimmeringLoaderView {

    var startAnimatingImp: () -> Void = { }
    func startAnimating() {

        startAnimatingImp()
    }

    var stopAnimatingImp: () -> Void = { }
    func stopAnimating() {

        stopAnimatingImp()
    }
}
