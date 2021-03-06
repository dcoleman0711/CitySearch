//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

struct LabelViewModel: Equatable {

    static let emptyData = LabelViewModel(text: "", font: .systemFont(ofSize: 12.0))

    let text: String
    let font: UIFont
}

protocol ViewBinder {

    func bindText(label: UILabel) -> ValueUpdate<LabelViewModel>

    func bindImage(imageView: UIImageView) -> ValueUpdate<UIImage?>
}

class ViewBinderImp: ViewBinder {

    func bindText(label: UILabel) -> ValueUpdate<LabelViewModel> {

        { (viewModel) in

            label.text = viewModel.text
            label.font = viewModel.font
        }
    }

    func bindImage(imageView: UIImageView) -> ValueUpdate<UIImage?> {

        { (image) in

            imageView.image = image
        }
    }
}
