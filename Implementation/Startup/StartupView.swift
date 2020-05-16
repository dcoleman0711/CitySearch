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
        let appTitleWidthConstraint = appTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        let appCenterXConstraint = appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let appCenterYConstraint = appTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let appTitleConstraints = [appTitleWidthConstraint, appCenterXConstraint, appCenterYConstraint]

        let constraints = [NSLayoutConstraint]([appTitleConstraints].joined())

        view.addConstraints(constraints)
    }
}