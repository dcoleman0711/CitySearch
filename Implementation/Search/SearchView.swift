//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchView {

    var view: UIView! { get }

    func loadViewIfNeeded()
}

class SearchViewImp: UIViewController, SearchView {

    private let searchResultsView: SearchResultsView

    convenience init() {

        self.init(initialData: CitySearchResults.emptyResults())
    }

    convenience init(initialData: CitySearchResults) {

        self.init(searchResultsView: SearchResultsViewImp(), modelFactory: SearchModelFactoryImp(), initialData: initialData)
    }

    init(searchResultsView: SearchResultsView, modelFactory: SearchModelFactory, initialData: CitySearchResults) {

        self.searchResultsView = searchResultsView

        modelFactory.searchModel(searchResultsModel: self.searchResultsView.model, initialData: initialData)

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

    private func setupView() {

        view.backgroundColor = UIColor.white

        view.addSubview(searchResultsView.view)
    }

    private func buildLayout() {

        // App Title
        searchResultsView.view.translatesAutoresizingMaskIntoConstraints = false
        let searchResultsLeftConstraint = searchResultsView.view.leftAnchor.constraint(equalTo: view.leftAnchor)
        let searchResultsRightConstraint = searchResultsView.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        let searchResultsTopConstraint = searchResultsView.view.topAnchor.constraint(equalTo: view.topAnchor)
        let searchResultsBottomConstraint = searchResultsView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let searchResultsViewContraints = [searchResultsLeftConstraint, searchResultsRightConstraint, searchResultsTopConstraint, searchResultsBottomConstraint]

        let constraints = [NSLayoutConstraint]([searchResultsViewContraints].joined())

        view.addConstraints(constraints)
    }
}