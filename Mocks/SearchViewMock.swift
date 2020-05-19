//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class SearchViewMock : UIViewControllerMock, SearchView {

}

class UIViewControllerMock: UIViewController {

    var navigationControllerMock: UINavigationController?
    override var navigationController: UINavigationController? {

        navigationControllerMock
    }
}