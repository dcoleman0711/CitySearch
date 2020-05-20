//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CityDetailsView where Self: UIViewController {


}

class CityDetailsViewImp : UIViewController, CityDetailsView {

    private let contentView: UIView

    private let titleLabel: UILabel
    private let populationTitleLabel: UILabel
    private let populationLabel: UILabel
    private let mapView: MapView
    private let imageCarouselView: ImageCarouselView

    private let viewModel: CityDetailsViewModel
    private let binder: ViewBinder

    init(contentView: UIView, titleLabel: UILabel, populationTitleLabel: UILabel, populationLabel: UILabel, mapView: MapView, imageCarouselView: ImageCarouselView, viewModel: CityDetailsViewModel, binder: ViewBinder) {

        self.contentView = contentView

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

    override func loadView() {

        self.view = UIScrollView()
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

        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(populationTitleLabel)
        populationTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(populationLabel)
        populationLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mapView.view)
        mapView.view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageCarouselView.view)
        imageCarouselView.view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout() {

        // Content View
        let contentViewConstraints = [contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                      contentView.topAnchor.constraint(equalTo: view.topAnchor),
                                      contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                      contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                      contentView.widthAnchor.constraint(equalTo: view.widthAnchor)]

        // Title Label
        let titleLabelConstraints = [titleLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
                                     titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor)]

        // Population Title Label
        let populationTitleLabelConstraints = [populationTitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
                                               populationTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.0)]

        // Population Label
        let populationLabelConstraints = [populationLabel.leftAnchor.constraint(equalTo: populationTitleLabel.rightAnchor, constant: 8.0),
                                          populationLabel.centerYAnchor.constraint(equalTo: populationTitleLabel.centerYAnchor)]

        // Map View
        let mapViewConstraints = [mapView.view.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor),
                                  mapView.view.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
                                  mapView.view.leftAnchor.constraint(equalTo: contentView.centerXAnchor),
                                  mapView.view.widthAnchor.constraint(equalTo: mapView.view.heightAnchor, multiplier: 2.0)]

        // Image Carousel View
        let imageCarouselViewConstraints = [imageCarouselView.view.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
                                            imageCarouselView.view.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor),
                                            imageCarouselView.view.topAnchor.constraint(equalTo: mapView.view.bottomAnchor, constant: 16.0),
                                            imageCarouselView.view.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
                                            imageCarouselView.view.heightAnchor.constraint(equalToConstant: 256.0)]

        let constraints = [NSLayoutConstraint]([contentViewConstraints,
                                                titleLabelConstraints,
                                                populationTitleLabelConstraints,
                                                populationLabelConstraints,
                                                mapViewConstraints,
                                                imageCarouselViewConstraints]
                .joined())

        view.addConstraints(constraints)
    }
}

class CityDetailsViewBuilder {

    func build(searchResult: CitySearchResult) -> CityDetailsView {

        let carouselModel = ImageCarouselModelImp()
        let carouselViewModel = ImageCarouselViewModelImp(model: carouselModel)
        let carouselView = ImageCarouselViewImp(viewModel: carouselViewModel)

        let model = CityDetailsModelImp(searchResult: searchResult, imageCarouselModel: carouselModel)
        let viewModel = CityDetailsViewModelImp(model: model)
        return CityDetailsViewImp(contentView: UIView(), titleLabel: UILabel(), populationTitleLabel: UILabel(), populationLabel: UILabel(), mapView: MapViewImp(searchResult: searchResult), imageCarouselView: carouselView, viewModel: viewModel, binder: ViewBinderImp())
    }
}