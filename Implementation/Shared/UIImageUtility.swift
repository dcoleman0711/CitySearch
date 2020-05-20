//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

extension UIImage {

    static func compareImages(lhs: UIImage?, rhs: UIImage?) -> Bool {

        guard let first = lhs,
              let firstPng = first.pngData(),
              let second = rhs,
              let secondPng = second.pngData() else {

            return lhs == rhs
        }

        return firstPng == secondPng
    }
}