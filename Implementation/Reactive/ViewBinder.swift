//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

typealias ValueUpdate<T> = (_ value: T) -> Void

func mapUpdate<In, Out>(_ out: @escaping ValueUpdate<Out>, _ mapFunction: @escaping (In) -> Out) -> ValueUpdate<In> {

    { inValue in out(mapFunction(inValue)) }
}

struct LabelViewModel: Equatable {

    static let emptyData = LabelViewModel(text: "", font: .systemFont(ofSize: 12.0))

    let text: String
    let font: UIFont
}

protocol ViewBinder {

    func bindText(label: UILabel) -> ValueUpdate<LabelViewModel>

    func bindImage(imageView: UIImageView) -> ValueUpdate<UIImage?>

    func bindFrame(view: UIView) -> ValueUpdate<CGRect>
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

    func bindFrame(view: UIView) -> ValueUpdate<CGRect> {

        // This is a risky API.  It assumes the view hierarch won't change, and that no other conflicting constraints are added. It should be used carefully.  AutoLayout and manual frame updating (which is what this ultimately is) don't mix well.
        guard let superview = view.superview else { return { frame in } }

        let xConstraint = view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: 0.0)
        let yConstraint = view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0.0)
        let widthConstraint = view.widthAnchor.constraint(equalToConstant: 0.0)
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: 0.0)

        var installed = false

        return { (frame) in

            xConstraint.constant = frame.origin.x
            yConstraint.constant = frame.origin.y
            widthConstraint.constant = frame.size.width
            heightConstraint.constant = frame.size.height

            if !installed {

                superview.addConstraints([xConstraint, yConstraint, widthConstraint, heightConstraint])
                installed = true
            }
        }
    }
}
