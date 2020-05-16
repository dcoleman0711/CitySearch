//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class ViewBinderMock : ViewBinder {

    var bindLabelTextImp: (_ label: UILabel) -> ValueUpdate<String> = { (label) in { (text) in } }
    func bindText(label: UILabel) -> ValueUpdate<String> {

        bindLabelTextImp(label)
    }
}
