//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol ParallaxView {

    var view: UIView { get }
}

class ParallaxViewImp: ParallaxView {

    let view = UIView()

    private let viewModel: ParallaxViewModel

    private var offsetConstraints: [NSLayoutConstraint] = []

    init(viewModel: ParallaxViewModel) {

        self.viewModel = viewModel

        viewModel.observeImages(ParallaxViewImp.buildImageViews(self))
        viewModel.observeOffsets(ParallaxViewImp.updateOffsets(self))
    }

    private func buildImageViews(_ images: [UIImage]) {

        self.offsetConstraints.removeAll()

        for view in view.subviews { view.removeFromSuperview() }
        for image in images { buildImageView(image) }
    }

    private func buildImageView(_ image: UIImage) {

        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)

        var constraints = [imageView.topAnchor.constraint(equalTo: view.topAnchor),
                           imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                           imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image.size.width / image.size.height)]

        let offsetConstraint = imageView.leftAnchor.constraint(equalTo: view.leftAnchor)

        self.offsetConstraints.append(offsetConstraint)

        constraints.append(offsetConstraint)
        view.addConstraints(constraints)
    }

    private func updateOffsets(_ offsets: [CGPoint]) {

        for (constraint, offset) in zip(offsetConstraints, offsets) {

            constraint.constant = offset.x
        }
    }
}