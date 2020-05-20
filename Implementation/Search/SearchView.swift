//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchView where Self: UIViewController {

}

class SearchViewImp: UIViewController, SearchView {

    private let searchResultsView: SearchResultsView

    init(searchResultsView: SearchResultsView, model: SearchModel) {

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

        view.addSubview(searchResultsView.view)
        searchResultsView.view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout() {

        // App Title
        let searchResultsViewContraints = [searchResultsView.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                                           searchResultsView.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                           searchResultsView.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                           searchResultsView.view.heightAnchor.constraint(equalToConstant: 256.0)]

        let constraints = [NSLayoutConstraint]([searchResultsViewContraints].joined())

        view.addConstraints(constraints)
    }
}

class SearchViewBuilder {

    var initialData = CitySearchResults.emptyResults()
    var searchResultsModelFactory: SearchResultsModelFactory = SearchResultsModelFactoryImp()
    var searchResultsViewFactory: SearchResultsViewFactory = SearchResultsViewFactoryImp()
    var modelFactory: SearchModelFactory = SearchModelFactoryImp()
    var cityDetailsViewFactory: CityDetailsViewFactory = CityDetailsViewFactoryImp()

    func build() -> SearchView {

        let openDetailsCommandFactory = OpenDetailsCommandFactoryImp(cityDetailsViewFactory: cityDetailsViewFactory)
        let searchResultsModel = searchResultsModelFactory.searchResultsModel(openDetailsCommandFactory: openDetailsCommandFactory)
        let searchResultsView = searchResultsViewFactory.searchResultsView(model: searchResultsModel)

        let model = modelFactory.searchModel(searchResultsModel: searchResultsModel)
        let searchView = SearchViewImp(searchResultsView: searchResultsView, model: model)

        openDetailsCommandFactory.searchView = searchView

        searchResultsModel.setResults(initialData)

        return searchView
    }
}