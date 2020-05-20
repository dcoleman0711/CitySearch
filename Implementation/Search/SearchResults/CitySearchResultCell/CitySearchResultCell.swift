//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class CitySearchResultCell : MVVMCollectionViewCell<CitySearchResultViewModel> {

    override var viewModel: CitySearchResultViewModel? {

        didSet {

            guard let viewModel = viewModel else { return }

            self.bindToViewModel(viewModel)
        }
    }

    private let titleLabel: UILabel
    private let imageView: UIImageView
    private let binder: ViewBinder

    private let updateTitle: ValueUpdate<LabelViewModel>

    convenience override init(frame: CGRect) {

        let imageView = UIImageView()
        imageView.image = UIImage(named: "TestImage.jpg")
        self.init(titleLabel: UILabel(), imageView: imageView, binder: ViewBinderImp())
    }

    init(titleLabel: UILabel, imageView: UIImageView, binder: ViewBinder) {

        self.titleLabel = titleLabel
        self.imageView = imageView
        self.binder = binder

        self.updateTitle = binder.bindText(label: self.titleLabel)

        super.init(frame: CGRect.zero)

        setupView()
        buildLayout()
    }

    private func setupView() {

        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.titleLabel.layer.cornerRadius = 8.0
        self.titleLabel.layer.borderWidth = 1.0
        self.titleLabel.layer.masksToBounds = true
        self.titleLabel.textAlignment = .center

        self.contentView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 52.0
        self.imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.imageView.contentMode = .scaleAspectFill
    }

    private func buildLayout() {

        // Title Label
        let titleLabelConstraints = [titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
                                     titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
                                     titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     titleLabel.heightAnchor.constraint(equalToConstant: 24.0)]

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

        viewModel.observeIconImage(self.binder.bindImage(imageView: self.imageView))
    }
}
