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

    private let backgroundImageView: UIImageView
    private let markerImageView: UIImageView
    private let viewModel: MapViewModel
    private let binder: ViewBinder

    convenience init() {

        self.init(backgroundImageView: UIImageView(), markerImageView: UIImageView(), viewModel: MapViewModelImp(), binder: ViewBinderImp())
    }

    init(backgroundImageView: UIImageView, markerImageView: UIImageView, viewModel: MapViewModel, binder: ViewBinder) {

        self.backgroundImageView = backgroundImageView
        self.markerImageView = markerImageView
        self.viewModel = viewModel
        self.binder = binder

        bindViews()

        setupView()
    }

    private func bindViews() {

        viewModel.observeBackgroundImage(binder.bindImage(imageView: backgroundImageView))
        viewModel.observeMarkerImage(binder.bindImage(imageView: markerImageView))
        viewModel.observeMarkerFrame(binder.bindFrame(view: markerImageView))
    }

    private func setupView() {

        view.addSubview(markerImageView)
        markerImageView.translatesAutoresizingMaskIntoConstraints = false
    }
}