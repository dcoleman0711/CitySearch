//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupViewModel {

    var model: StartupModel { get }

    func observeAppTitle(_ observer: @escaping ValueUpdate<LabelViewModel>)
}

class StartupViewModelImp: StartupViewModel {

    let model: StartupModel

    private var appTitleObserver: ValueUpdate<LabelViewModel>?

    private var appTitle: LabelViewModel = LabelViewModel.emptyData {

        didSet { appTitleObserver?(appTitle) }
    }

    init(model: StartupModel) {

        self.model = model

        self.model.observeAppTitleText(StartupViewModelImp.appTextUpdated(self))
    }

    func observeAppTitle(_ observer: @escaping ValueUpdate<LabelViewModel>) {

        self.appTitleObserver = observer

        observer(appTitle)
    }

    private func appTextUpdated(appTitleText: String) {

        self.appTitle = LabelViewModel(text: appTitleText, font: UIFont.systemFont(ofSize: 48.0))
    }
}
