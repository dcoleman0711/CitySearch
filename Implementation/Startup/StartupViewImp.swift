//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupView {

    var view: UIView { get }
}

class StartupViewImp : StartupView {

    let view = UIView()

    private let appTitleLabel: UILabel

    private let model: StartupModel
    private let binder: ViewBinder

    init(appTitleLabel: UILabel, model: StartupModel, binder: ViewBinder) {

        self.appTitleLabel = appTitleLabel
        self.model = model
        self.binder = binder

        setupView()
        buildLayout()
        bindViews()
    }

    private func setupView() {

        view.backgroundColor = UIColor.white

        view.addSubview(appTitleLabel)

        appTitleLabel.font = UIFont.systemFont(ofSize: 48.0)
    }

    private func buildLayout() {

        // App Title
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let appCenterXConstraint = appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let appCenterYConstraint = appTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let appTitleConstraints = [appCenterXConstraint, appCenterYConstraint]

        let constraints = [NSLayoutConstraint]([appTitleConstraints].joined())

        view.addConstraints(constraints)
    }

    private func bindViews() {

        model.observeAppTitleText(binder.bindText(label: appTitleLabel))
    }
}