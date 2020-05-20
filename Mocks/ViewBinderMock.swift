//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class ViewBinderMock : ViewBinder {

    var bindLabelTextImp: (_ label: UILabel) -> ValueUpdate<LabelViewModel> = { (label) in { text in } }
    func bindText(label: UILabel) -> ValueUpdate<LabelViewModel> {

        bindLabelTextImp(label)
    }

    var bindImageImp: (_ imageView: UIImageView) -> ValueUpdate<UIImage?> = { imageView in { image in } }
    func bindImage(imageView: UIImageView) -> ValueUpdate<UIImage?> {

        bindImageImp(imageView)
    }

    var bindFrameImp: (_ view: UIView) -> ValueUpdate<CGRect> = { view in { frame in }}
    func bindFrame(view: UIView) -> ValueUpdate<CGRect> {

        bindFrameImp(view)
    }
}
