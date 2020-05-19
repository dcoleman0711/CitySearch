//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupView where Self: UIViewController {


}

class StartupViewImp : UIViewController, StartupView {

    private let appTitleLabel: UILabel

    private let viewModel: StartupViewModel
    private let binder: ViewBinder

    init(appTitleLabel: UILabel, viewModel: StartupViewModel, binder: ViewBinder) {

        self.appTitleLabel = appTitleLabel
        self.viewModel = viewModel
        self.binder = binder

        super.init(nibName: nil, bundle: nil)

        bindViews()
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder!")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        setupView()
        buildLayout()

        viewModel.model.startTransitionTimer()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        UIInterfaceOrientationMask.landscape
    }

    private func setupView() {

        view.backgroundColor = UIColor.white

        view.addSubview(appTitleLabel)
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

        viewModel.observeAppTitle(binder.bindText(label: appTitleLabel))
    }
}