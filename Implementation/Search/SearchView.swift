//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchView where Self: UIViewController {

}

class SearchViewImp: UIViewController, SearchView {

    private let parallaxView: ParallaxView
    private let searchResultsView: SearchResultsView

    private let viewModel: SearchViewModel

    init(parallaxView: ParallaxView, searchResultsView: SearchResultsView, viewModel: SearchViewModel) {

        self.parallaxView = parallaxView
        self.searchResultsView = searchResultsView

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
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        UIInterfaceOrientationMask.landscape
    }

    private func setupView() {

        view.backgroundColor = UIColor.white

        view.addSubview(parallaxView.view)
        parallaxView.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(searchResultsView.view)
        searchResultsView.view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout() {

        // Parallax
        let parallaxViewConstraints = [parallaxView.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                                       parallaxView.view.rightAnchor.constraint(equalTo: view.rightAnchor),
                                       parallaxView.view.topAnchor.constraint(equalTo: view.topAnchor),
                                       parallaxView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)]

        // Search Results
        let searchResultsViewContraints = [searchResultsView.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                                           searchResultsView.view.rightAnchor.constraint(equalTo: view.rightAnchor),
                                           searchResultsView.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                           searchResultsView.view.heightAnchor.constraint(equalToConstant: 312.0)]

        let constraints = [NSLayoutConstraint]([parallaxViewConstraints, searchResultsViewContraints].joined())

        view.addConstraints(constraints)
    }
}

class SearchViewBuilder {

    var initialData = CitySearchResults.emptyResults()

    var parallaxViewFactory: ParallaxViewFactory = ParallaxViewFactoryImp()
    var parallaxViewModelFactory: ParallaxViewModelFactory = ParallaxViewModelFactoryImp()

    var searchResultsModelFactory: SearchResultsModelFactory = SearchResultsModelFactoryImp()
    var searchResultsViewModelFactory: SearchResultsViewModelFactory = SearchResultsViewModelFactoryImp()
    var searchResultsViewFactory: SearchResultsViewFactory = SearchResultsViewFactoryImp()

    var modelFactory: SearchModelFactory = SearchModelFactoryImp()
    var viewModelFactory: SearchViewModelFactory = SearchViewModelFactoryImp()

    var cityDetailsViewFactory: CityDetailsViewFactory = CityDetailsViewFactoryImp()

    func build() -> SearchView {

        let parallaxModel = ParallaxModelImp()
        let parallaxViewModel = parallaxViewModelFactory.parallaxViewModel(model: parallaxModel)
        let parallaxView = parallaxViewFactory.parallaxView(viewModel: parallaxViewModel)

        let openDetailsCommandFactory = OpenDetailsCommandFactoryImp(cityDetailsViewFactory: cityDetailsViewFactory)
        let searchResultsModel = searchResultsModelFactory.searchResultsModel(openDetailsCommandFactory: openDetailsCommandFactory)
        let searchResultsViewModel = searchResultsViewModelFactory.searchResultsViewModel(model: searchResultsModel, viewModelFactory: CitySearchResultViewModelFactoryImp())
        let searchResultsView = searchResultsViewFactory.searchResultsView(viewModel: searchResultsViewModel)

        let model = modelFactory.searchModel(parallaxModel: parallaxModel, searchResultsModel: searchResultsModel)
        let viewModel = viewModelFactory.searchViewModel(model: model, parallaxViewModel: parallaxViewModel, searchResultsViewModel: searchResultsViewModel)
        let searchView = SearchViewImp(parallaxView: parallaxView, searchResultsView: searchResultsView, viewModel: viewModel)

        openDetailsCommandFactory.searchView = searchView

        searchResultsModel.setResults(initialData)

        return searchView
    }
}