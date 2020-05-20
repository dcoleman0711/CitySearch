//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class RollingAnimationLabelMock: UIView, RollingAnimationLabel {

    var startImp: (_ text: String, _ font: UIFont) -> Void = { text, font in }
    func start(with text: String, font: UIFont) {

        startImp(text, font)
    }
}
