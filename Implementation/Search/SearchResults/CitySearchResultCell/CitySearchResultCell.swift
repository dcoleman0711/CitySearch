//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class CitySearchResultCell : MVVMCollectionViewCell<CitySearchResultViewModel> {

    convenience override init(frame: CGRect) {

        self.init(titleLabel: UILabel())
    }

    init(titleLabel: UILabel) {

        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder!")
    }
}
