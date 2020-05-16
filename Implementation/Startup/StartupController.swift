//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class StartupController: UIViewController {

    private let startupView: StartupView

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

    public class Builder {

        public var appTitleLabel = UILabel()

        private let viewFactory: StartupViewFactory

        convenience init() {

            self.init(viewFactory: StartupViewFactoryImp())
        }

        init(viewFactory: StartupViewFactory) {

            self.viewFactory = viewFactory
        }

        func build() -> StartupController {

            let startupView = viewFactory.startupView(appTitleLabel: appTitleLabel, startupModel: StartupModelImp(), binder: ViewBinderImp())

            return StartupController(startupView: startupView)
        }
    }
}

