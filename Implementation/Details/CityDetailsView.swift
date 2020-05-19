//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CityDetailsView where Self: UIViewController {


}

class CityDetailsViewImp : UIViewController, CityDetailsView {

    private let titleLabel: UILabel

    convenience init() {

        self.init(titleLabel: UILabel())
    }

    init(titleLabel: UILabel) {

        self.titleLabel = titleLabel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {

        fatalError("No interface builder!")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        setupView()
        buildLayout()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        UIInterfaceOrientationMask.landscape
    }

    private func setupView() {

        view.backgroundColor = .white

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout() {

        // Title Label
        let titleLabelXConstraint = titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        let titleLabelYConstraint = titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let titleLabelConstraints = [titleLabelXConstraint, titleLabelYConstraint]

        let constraints = [NSLayoutConstraint]([titleLabelConstraints].joined())

        view.addConstraints(constraints)
    }
}
