//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupView where Self: UIViewController {


}

class StartupViewImp : UIViewController, StartupView {

    private let appTitleLabel: RollingAnimationLabel

    private let viewModel: StartupViewModel

    init(appTitleLabel: RollingAnimationLabel, viewModel: StartupViewModel) {

        self.appTitleLabel = appTitleLabel
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder!")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        setupView()
        buildLayout()

        viewModel.model.startTransitionTimer()

        bindViews()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        UIInterfaceOrientationMask.landscape
    }

    private func setupView() {

        view.backgroundColor = UIColor.white

        view.addSubview(appTitleLabel)
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout() {

        // App Title
        let appTitleConstraints = [appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                   appTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)]

        let constraints = [NSLayoutConstraint]([appTitleConstraints].joined())

        view.addConstraints(constraints)
    }

    private func bindViews() {

        viewModel.observeAppTitle { viewModel in self.appTitleLabel.start(with: viewModel.text, font: viewModel.font) }
    }
}