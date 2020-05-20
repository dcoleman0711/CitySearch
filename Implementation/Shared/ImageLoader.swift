//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class ImageLoader {

    static func loadImage(name: String) -> UIImage? {

        UIImage(named: name, in: Bundle(for: ImageLoader.self), with: nil)
    }
}