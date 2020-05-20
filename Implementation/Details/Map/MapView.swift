//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol MapView  {

    var view: UIView { get }
}

class MapViewImp: MapView {

    var view: UIView { backgroundImageView }

    private var backgroundImageView: UIImageView
    private var viewModel: MapViewModel
    private var binder: ViewBinder

    convenience init() {

        self.init(backgroundImageView: UIImageView(), viewModel: MapViewModelImp(), binder: ViewBinderImp())
    }

    init(backgroundImageView: UIImageView, viewModel: MapViewModel, binder: ViewBinder) {

        self.backgroundImageView = backgroundImageView
        self.viewModel = viewModel
        self.binder = binder

        bindViews()
    }

    private func bindViews() {

        viewModel.observeBackgroundImage(binder.bindImage(imageView: backgroundImageView))
    }
}