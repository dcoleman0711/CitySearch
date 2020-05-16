//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchResultsView {

    var view: UIView { get }
}

class SearchResultsViewImp : SearchResultsView {

    let view = UIView()
}