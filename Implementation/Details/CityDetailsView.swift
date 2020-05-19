//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CityDetailsView where Self: UIViewController {


}

class CityDetailsViewImp : UIViewController, CityDetailsView {

    override func viewDidLoad() {

        super.viewDidLoad()

        setupView()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        UIInterfaceOrientationMask.portrait
    }

    private func setupView() {

        view.backgroundColor = .white
    }
}