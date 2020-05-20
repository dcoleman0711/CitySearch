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

    private let markerXConstraint: NSLayoutConstraint
    private let markerYConstraint: NSLayoutConstraint

    private let markerSize = CGSize(width: 16.0, height: 16.0)

    convenience init() {

        self.init(backgroundImageView: UIImageView(), markerImageView: UIImageView(), viewModel: MapViewModelImp(), binder: ViewBinderImp())
    }

    init(backgroundImageView: UIImageView, markerImageView: UIImageView, viewModel: MapViewModel, binder: ViewBinder) {

        self.backgroundImageView = backgroundImageView
        self.markerImageView = markerImageView
        self.viewModel = viewModel
        self.binder = binder

        self.markerXConstraint = markerImageView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 0.0)
        self.markerYConstraint = markerImageView.bottomAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 0.0)

        bindViews()

        setupView()
        buildLayout()
    }

    private func bindViews() {

        viewModel.observeBackgroundImage(binder.bindImage(imageView: backgroundImageView))
        viewModel.observeMarkerImage(binder.bindImage(imageView: markerImageView))
        viewModel.observeMarkerPosition(MapViewImp.updateMarkerPosition(self))
    }

    private func setupView() {

        view.addSubview(markerImageView)
        markerImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func buildLayout() {

        // Marker Image
        let markerImageViewConstraints = [markerXConstraint,
                                          markerYConstraint,
                                          markerImageView.widthAnchor.constraint(equalToConstant: markerSize.width),
                                          markerImageView.heightAnchor.constraint(equalToConstant: markerSize.height)]

        let constraints = [NSLayoutConstraint]([markerImageViewConstraints].joined())

        view.addConstraints(constraints)
    }

    private func updateMarkerPosition(_ position: CGPoint) {

        markerXConstraint.constant = position.x
        markerYConstraint.constant = position.y
    }
}