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

    init(parallaxView: ParallaxView, searchResultsView: SearchResultsView, model: SearchModel) {

        self.parallaxView = parallaxView
        self.searchResultsView = searchResultsView

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
        let searchResultsViewContraints = [searchResultsView.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                                           searchResultsView.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                           searchResultsView.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                           searchResultsView.view.heightAnchor.constraint(equalToConstant: 256.0)]

        let constraints = [NSLayoutConstraint]([parallaxViewConstraints, searchResultsViewContraints].joined())

        view.addConstraints(constraints)
    }
}

class SearchViewBuilder {

    var initialData = CitySearchResults.emptyResults()
    var searchResultsModelFactory: SearchResultsModelFactory = SearchResultsModelFactoryImp()
    var searchResultsViewFactory: SearchResultsViewFactory = SearchResultsViewFactoryImp()
    var modelFactory: SearchModelFactory = SearchModelFactoryImp()
    var cityDetailsViewFactory: CityDetailsViewFactory = CityDetailsViewFactoryImp()
    var parallaxView: ParallaxView = ParallaxViewImp()

    func build() -> SearchView {

        let openDetailsCommandFactory = OpenDetailsCommandFactoryImp(cityDetailsViewFactory: cityDetailsViewFactory)
        let searchResultsModel = searchResultsModelFactory.searchResultsModel(openDetailsCommandFactory: openDetailsCommandFactory)
        let searchResultsView = searchResultsViewFactory.searchResultsView(model: searchResultsModel)

        let model = modelFactory.searchModel(searchResultsModel: searchResultsModel)
        let searchView = SearchViewImp(parallaxView: parallaxView, searchResultsView: searchResultsView, model: model)

        openDetailsCommandFactory.searchView = searchView

        searchResultsModel.setResults(initialData)

        return searchView
    }
}