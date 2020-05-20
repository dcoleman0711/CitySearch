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

    private var markerPositionConstraints: [NSLayoutConstraint] = []

    private var layoutGuide: UILayoutGuide

    private var markerWidthConstraint: NSLayoutConstraint
    private var markerHeightConstraint: NSLayoutConstraint

    convenience init(searchResult: CitySearchResult) {

        self.init(backgroundImageView: UIImageView(), markerImageView: UIImageView(), viewModel: MapViewModelImp(searchResult: searchResult), binder: ViewBinderImp())
    }

    init(backgroundImageView: UIImageView, markerImageView: UIImageView, viewModel: MapViewModel, binder: ViewBinder) {

        self.backgroundImageView = backgroundImageView
        self.markerImageView = markerImageView
        self.viewModel = viewModel
        self.binder = binder

        self.markerWidthConstraint = markerImageView.widthAnchor.constraint(equalToConstant: 0.0)
        self.markerHeightConstraint = markerImageView.heightAnchor.constraint(equalToConstant: 0.0)

        self.layoutGuide = UILayoutGuide()

        setupView()

        buildLayout()
        bindViews()
    }

    private func buildLayout() {

        // Marker Image View
        let markerImageViewConstraints = [markerWidthConstraint,
                                          markerHeightConstraint,
                                          markerImageView.leftAnchor.constraint(equalTo: layoutGuide.rightAnchor),
                                          markerImageView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)]

        let constraints = [NSLayoutConstraint]([markerImageViewConstraints].joined())

        view.addConstraints(constraints)
    }

    private func bindViews() {

        viewModel.observeBackgroundImage(binder.bindImage(imageView: backgroundImageView))
        viewModel.observeMarkerImage(binder.bindImage(imageView: markerImageView))
        viewModel.observeMarkerFrame(MapViewImp.updateMarkerFrame(self))
    }

    private func setupView() {

        view.addSubview(markerImageView)
        markerImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addLayoutGuide(layoutGuide)
    }

    private func updateMarkerFrame(_ frame: CGRect) {

        updatePositionConstraints(for: frame.origin)

        markerWidthConstraint.constant = frame.size.width
        markerHeightConstraint.constant = frame.size.height
    }

    private func updatePositionConstraints(for position: CGPoint) {

        let constraints = [layoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: position.x),
                           layoutGuide.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: position.y)]

        view.removeConstraints(markerPositionConstraints)
        view.addConstraints(constraints)

        self.markerPositionConstraints = constraints
    }
}
