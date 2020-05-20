//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class CADisplayLinkFactoryMock: CADisplayLinkFactory {

    var displayLinkImp: (_ target: Any, _ selector: Selector) -> CADisplayLink = { target, selector in CADisplayLinkMock() }
    func displayLink(target: Any, selector: Selector) -> CADisplayLink {

        displayLinkImp(target, selector)
    }

}
