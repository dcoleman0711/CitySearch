//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class CitySearchResultCell : MVVMCollectionViewCell<CitySearchResultViewModel> {

    override var viewModel: CitySearchResultViewModel? {

        didSet {

            self.update()
        }
    }

    private let titleLabel: UILabel

    convenience override init(frame: CGRect) {

        self.init(titleLabel: UILabel())
    }

    init(titleLabel: UILabel) {

        self.titleLabel = titleLabel

        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder!")
    }

    private func update() {

        self.titleLabel.text = viewModel?.titleText
    }
}
