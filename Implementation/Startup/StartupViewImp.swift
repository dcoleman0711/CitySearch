//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupView {

    var view: UIView! { get }
}

class StartupViewImp : UIViewController, StartupView {

    private let appTitleLabel: UILabel

    private let model: StartupModel
    private let binder: ViewBinder

    init(appTitleLabel: UILabel, model: StartupModel, binder: ViewBinder) {

        self.appTitleLabel = appTitleLabel
        self.model = model
        self.binder = binder

        super.init(nibName: nil, bundle: nil)

        bindViews()
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder!")
    }

    override func viewDidLoad() {

        setupView()
        buildLayout()

        model.startTransitionTimer()
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

    class Builder {

        var appTitleLabel = UILabel()
        var transitionCommand: StartupTransitionCommand = StartupTransitionCommandImp()

        func build() -> StartupViewImp {

            StartupViewImp(appTitleLabel: appTitleLabel, model: StartupModelImp(), binder: ViewBinderImp())
        }
    }
}