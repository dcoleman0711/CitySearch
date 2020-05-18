//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

typealias ValueUpdate<T> = (_ value: T) -> Void

protocol ViewBinder {

    func bindText(label: UILabel) -> ValueUpdate<NSAttributedString>
}

class ViewBinderImp: ViewBinder {

    func bindText(label: UILabel) -> ValueUpdate<NSAttributedString> {

        { (text) in label.attributedText = text }
    }
}