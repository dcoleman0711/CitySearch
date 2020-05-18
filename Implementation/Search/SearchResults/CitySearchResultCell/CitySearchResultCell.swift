//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class CitySearchResultCell : MVVMCollectionViewCell<CitySearchResultViewModel> {

    override var viewModel: CitySearchResultViewModel? {

        didSet {

            guard let viewModel = viewModel else {
                return
            }

            self.bindToViewModel(viewModel)
        }
    }

    private let titleLabel: UILabel
    private let imageView: UIImageView

    private let updateTitle: ValueUpdate<LabelViewModel>

    convenience override init(frame: CGRect) {

        self.init(titleLabel: UILabel(), imageView: UIImageView(), binder: ViewBinderImp())
    }

    init(titleLabel: UILabel, imageView: UIImageView, binder: ViewBinder) {

        self.titleLabel = titleLabel
        self.imageView = imageView

        self.updateTitle = binder.bindText(label: self.titleLabel)

        super.init(frame: CGRect.zero)

        setupView()
        buildLayout()
    }

    private func setupView() {

        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout() {

        // Title Label
        let titleLabelXConstraint = titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let titleLabelYConstraint = titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let titleLabelConstraints = [titleLabelXConstraint, titleLabelYConstraint]

        // ImageView
        let imageViewAspectRatioConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        let imageViewXConstraint = imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: self.topAnchor)
        let imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor)
        let imageViewConstraints = [imageViewAspectRatioConstraint, imageViewXConstraint, imageViewTopConstraint, imageViewBottomConstraint]

        let constraints = [NSLayoutConstraint]([titleLabelConstraints, imageViewConstraints].joined())

        self.addConstraints(constraints)
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder!")
    }

    private func bindToViewModel(_ viewModel: CitySearchResultViewModel) {

        self.updateTitle(viewModel.titleData)
    }
}
