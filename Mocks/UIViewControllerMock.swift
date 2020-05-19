//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class UIViewControllerMock: UIViewController {

    var supportedInterfaceOrientationsMock = UIInterfaceOrientationMask.all
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        supportedInterfaceOrientationsMock
    }

    var navigationControllerMock: UINavigationController?
    override var navigationController: UINavigationController? {

        navigationControllerMock
    }
}