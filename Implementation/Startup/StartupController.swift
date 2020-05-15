//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class StartupController: UIViewController {

    let startupView: StartupView

    convenience init() {

        self.init(startupView: StartupView())
    }

    init(startupView: StartupView) {

        self.startupView = startupView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {

        fatalError("No Interface Builder!")
    }

    override func loadView() {

        self.view = startupView.view
    }
}

