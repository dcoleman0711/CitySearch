//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class AsyncImageCell : MVVMCollectionViewCell<AsyncImageViewModel> {

    override var viewModel: AsyncImageViewModel? {

        didSet {

            guard let viewModel = self.viewModel else { return }

            bindViews(to: viewModel)
        }
    }

    private let imageView: UIImageView
    private let binder: ViewBinder

    init(imageView: UIImageView, binder: ViewBinder) {

        self.imageView = imageView
        self.binder = binder

        super.init(frame: .zero)

        setupView()
        buildLayout()
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder")
    }

    private func bindViews(to viewModel: AsyncImageViewModel) {

        viewModel.observeImage(binder.bindImage(imageView: imageView))
    }

    private func setupView() {

        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout() {

        // Image View
        let imageViewConstraints = [imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
                                    imageView.topAnchor.constraint(equalTo: self.topAnchor),
                                    imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
                                    imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)]

        let constraints = [NSLayoutConstraint]([imageViewConstraints].joined())

        self.addConstraints(constraints)
    }
}
