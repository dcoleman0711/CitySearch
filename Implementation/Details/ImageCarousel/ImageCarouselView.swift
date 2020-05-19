//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol ImageCarouselView {

    var view: UIView { get }
}

class ImageCarouselViewImp: ImageCarouselView {

    let view = UIView()
}