//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchView where Self: UIViewController {

}

class SearchViewImp: UIViewController, SearchView {

    private let searchResultsView: SearchResultsView

    init(searchResultsView: SearchResultsView, model: SearchModel, initialData: CitySearchResults) {

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
    }

    private func buildLayout() {

        // App Title
        searchResultsView.view.translatesAutoresizingMaskIntoConstraints = false
        let searchResultsLeftConstraint = searchResultsView.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        let searchResultsRightConstraint = searchResultsView.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        let searchResultsTopConstraint = searchResultsView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let searchResultsBottomConstraint = searchResultsView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let searchResultsViewContraints = [searchResultsLeftConstraint, searchResultsRightConstraint, searchResultsTopConstraint, searchResultsBottomConstraint]

        let constraints = [NSLayoutConstraint]([searchResultsViewContraints].joined())

        view.addConstraints(constraints)
    }
}

class SearchViewBuilder {

    var initialData = CitySearchResults.emptyResults()
    var searchResultsModelFactory: SearchResultsModelFactory = SearchResultsModelFactoryImp()
    var searchResultsViewFactory: SearchResultsViewFactory = SearchResultsViewFactoryImp()
    var modelFactory: SearchModelFactory = SearchModelFactoryImp()

    func build() -> SearchView {

        let openDetailsCommandFactory = OpenDetailsCommandFactoryImp(cityDetailsViewFactory: CityDetailsViewFactoryImp())
        let searchResultsModel = searchResultsModelFactory.searchResultsModel(openDetailsCommandFactory: openDetailsCommandFactory)
        let searchResultsView = searchResultsViewFactory.searchResultsView(model: searchResultsModel)

        let model = modelFactory.searchModel(searchResultsModel: searchResultsModel, initialData: initialData)
        let searchView = SearchViewImp(searchResultsView: searchResultsView, model: model, initialData: initialData)

        openDetailsCommandFactory.searchView = searchView

        return searchView
    }
}