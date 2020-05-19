//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CityDetailsView where Self: UIViewController {


}

class CityDetailsViewImp : UIViewController, CityDetailsView {

    private let titleLabel: UILabel
    private let populationTitleLabel: UILabel

    private let viewModel: CityDetailsViewModel
    private let binder: ViewBinder

    convenience init(searchResult: CitySearchResult) {

        let model = CityDetailsModelImp(searchResult: searchResult)
        let viewModel = CityDetailsViewModelImp(model: model)
        self.init(titleLabel: UILabel(), populationTitleLabel: UILabel(), viewModel: viewModel, binder: ViewBinderImp())
    }

    init(titleLabel: UILabel, populationTitleLabel: UILabel, viewModel: CityDetailsViewModel, binder: ViewBinder) {

        self.titleLabel = titleLabel
        self.populationTitleLabel = populationTitleLabel
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
        viewModel.observePopulationTitle(binder.bindText(label: populationTitleLabel))
    }

    private func setupView() {

        view.backgroundColor = .white

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(populationTitleLabel)
        populationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout() {

        // Title Label
        let titleLabelXConstraint = titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        let titleLabelYConstraint = titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let titleLabelConstraints = [titleLabelXConstraint, titleLabelYConstraint]

        // Population Title Label
        let populationTitleLabelXConstraint = populationTitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
        let populationTitleLabelYConstraint = populationTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.0)
        let populationTitleLabelConstraints = [populationTitleLabelXConstraint, populationTitleLabelYConstraint]
        
        let constraints = [NSLayoutConstraint]([titleLabelConstraints, populationTitleLabelConstraints].joined())

        view.addConstraints(constraints)
    }
}
