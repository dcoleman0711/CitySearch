//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class StartupView {

    let view = UIView()

    let appTitleLabel = UILabel()

    init() {

        view.backgroundColor = UIColor.white

        view.addSubview(appTitleLabel)

        buildLayout()
    }

    private func buildLayout() {

        // App Title
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let appTitleWidthConstraint = NSLayoutConstraint(item: appTitleLabel, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0.0)
        let appTitleConstraints = [appTitleWidthConstraint]

        let constraints = [NSLayoutConstraint]([appTitleConstraints].joined())

        view.addConstraints(constraints)
    }
}