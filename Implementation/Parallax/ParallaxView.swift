//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol ParallaxView {

    var view: UIView { get }
}

class ParallaxViewImp: ParallaxView {

    let view = UIView()
}