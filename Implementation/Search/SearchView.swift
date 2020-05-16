//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchView {

    var view: UIView! { get }
}

class SearchViewImp: UIViewController, SearchView {

    private let searchResultsView: SearchResultsView

    convenience init() {

        self.init(searchResultsView: SearchResultsViewImp())
    }

    init(searchResultsView: SearchResultsView) {

        self.searchResultsView = searchResultsView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder!")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        view.addSubview(searchResultsView.view)
    }
}