//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CityDetailsView where Self: UIViewController {


}

class CityDetailsViewImp : UIViewController, CityDetailsView {

    private let titleLabel: UILabel
    private let viewModel: CityDetailsViewModel
    private let binder: ViewBinder

    convenience init(searchResult: CitySearchResult) {

        let model = CityDetailsModelImp(searchResult: searchResult)
        let viewModel = CityDetailsViewModelImp(model: model)
        self.init(titleLabel: UILabel(), viewModel: viewModel, binder: ViewBinderImp())
    }

    init(titleLabel: UILabel, viewModel: CityDetailsViewModel, binder: ViewBinder) {

        self.titleLabel = titleLabel
        self.viewModel = viewModel
        self.binder = binder

        super.init(nibName: nil, bundle: nil)

        bindViews()
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

    private func bindViews() {

        viewModel.observeTitle(binder.bindText(label: titleLabel))
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
