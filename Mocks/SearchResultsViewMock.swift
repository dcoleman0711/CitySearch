//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class SearchResultsViewMock : SearchResultsView {

    var viewGetter: () -> UIView = { UIView() }
    var view: UIView { viewGetter() }
}
