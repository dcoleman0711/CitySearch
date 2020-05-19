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
    private let populationLabel: UILabel
    private let mapView: MapView
    private let imageCarouselView: ImageCarouselView

    private let viewModel: CityDetailsViewModel
    private let binder: ViewBinder

    convenience init(searchResult: CitySearchResult) {

        let model = CityDetailsModelImp(searchResult: searchResult)
        let viewModel = CityDetailsViewModelImp(model: model)
        self.init(titleLabel: UILabel(), populationTitleLabel: UILabel(), populationLabel: UILabel(), mapView: MapViewImp(), imageCarouselView: ImageCarouselViewImp(), viewModel: viewModel, binder: ViewBinderImp())
    }

    init(titleLabel: UILabel, populationTitleLabel: UILabel, populationLabel: UILabel, mapView: MapView, imageCarouselView: ImageCarouselView, viewModel: CityDetailsViewModel, binder: ViewBinder) {

        self.titleLabel = titleLabel
        self.populationTitleLabel = populationTitleLabel
        self.populationLabel = populationLabel
        self.mapView = mapView
        self.imageCarouselView = imageCarouselView
        
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
        viewModel.observePopulation(binder.bindText(label: populationLabel))
    }

    private func setupView() {

        view.backgroundColor = .white

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(populationTitleLabel)
        populationTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(populationLabel)
        populationLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mapView.view)
        mapView.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageCarouselView.view)
        imageCarouselView.view.translatesAutoresizingMaskIntoConstraints = false
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

        // Population Label
        let populationLabelXConstraint = populationLabel.leftAnchor.constraint(equalTo: populationTitleLabel.rightAnchor, constant: 8.0)
        let populationLabelYConstraint = populationLabel.centerYAnchor.constraint(equalTo: populationTitleLabel.centerYAnchor)
        let populationLabelConstraints = [populationLabelXConstraint, populationLabelYConstraint]

        // Map View
        let mapViewXConstraint = mapView.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        let mapViewYConstraint = mapView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let mapViewWidthConstraint = mapView.view.leftAnchor.constraint(equalTo: view.centerXAnchor)
        let mapViewAspectRatioConstraint = mapView.view.widthAnchor.constraint(equalTo: mapView.view.heightAnchor, multiplier: 2.0)
        let mapViewConstraints = [mapViewXConstraint, mapViewYConstraint, mapViewWidthConstraint, mapViewAspectRatioConstraint]

        // Image Carousel View
        let imageCarouselViewLeftConstraint = imageCarouselView.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        let imageCarouselViewRightConstraint = imageCarouselView.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        let imageCarouselViewTopConstraint = imageCarouselView.view.topAnchor.constraint(equalTo: mapView.view.bottomAnchor, constant: 16.0)
        let imageCarouselViewHeightConstraint = imageCarouselView.view.heightAnchor.constraint(equalToConstant: 256.0)
        let imageCarouselViewConstraints = [imageCarouselViewLeftConstraint, imageCarouselViewRightConstraint, imageCarouselViewTopConstraint, imageCarouselViewHeightConstraint]

        let constraints = [NSLayoutConstraint]([titleLabelConstraints, populationTitleLabelConstraints, populationLabelConstraints, mapViewConstraints, imageCarouselViewConstraints].joined())

        view.addConstraints(constraints)
    }
}
