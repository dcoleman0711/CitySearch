//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CADisplayLinkFactory {

    func displayLink(target: Any, selector: Selector) -> CADisplayLink
}

class CADisplayLinkFactoryImp: CADisplayLinkFactory {

    func displayLink(target: Any, selector: Selector) -> CADisplayLink {

        CADisplayLink(target: target, selector: selector)
    }
}
