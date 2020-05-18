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

    private let updateTitle: ValueUpdate<LabelViewModel>

    convenience override init(frame: CGRect) {

        self.init(titleLabel: UILabel(), binder: ViewBinderImp())
    }

    init(titleLabel: UILabel, binder: ViewBinder) {

        self.titleLabel = titleLabel

        self.updateTitle = binder.bindText(label: self.titleLabel)

        super.init(frame: CGRect.zero)

        setupView()
        buildLayout()
    }

    private func setupView() {

        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout() {

        // Title Label
        let titleLabelXConstraint = titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let titleLabelYConstraint = titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let titleLabelConstraints = [titleLabelXConstraint, titleLabelYConstraint]

        let constraints = [NSLayoutConstraint]([titleLabelConstraints].joined())

        self.addConstraints(constraints)
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder!")
    }

    private func bindToViewModel(_ viewModel: CitySearchResultViewModel) {

        self.updateTitle(viewModel.titleData)
    }
}
