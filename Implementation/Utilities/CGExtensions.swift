//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

extension CGRect {

    var center: CGPoint { CGPoint(x: origin.x + size.width / 2.0, y: origin.y + size.height / 2.0) }

    var topLeft: CGPoint { origin }
    var topRight: CGPoint { CGPoint(x: origin.x + size.width, y: origin.y) }
    var bottomLeft: CGPoint { CGPoint(x: origin.x, y: origin.y + size.height) }
    var bottomRight: CGPoint { CGPoint(x: origin.x + size.width, y: origin.y + size.height) }
}