//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol RollingAnimationLabel where Self: UIView {

    func start(with text: String, font: UIFont)
}

class RollingAnimationLabelImp: UIView, RollingAnimationLabel {

    private var text: String = ""
    private var font: UIFont = UIFont.systemFont(ofSize: 12.0)

    // These can easily be exposed for configurability
    private var animationCurve: (CFTimeInterval) -> CFTimeInterval = RollingAnimationLabelImp.easeOutBackCurve
    private var totalDuration: CFTimeInterval = 4.0
    private var characterDuration: CFTimeInterval = 1.0

    private var characterViews: [UILabel] = []

    private var displayLink: CADisplayLink!

    private var startTime: CFTimeInterval?

    private var startTimes: [UILabel: CFTimeInterval] = [:]
    private var characterConstraints: [UILabel: NSLayoutConstraint] = [:]
    private var xFinalOffsets: [UILabel: CGFloat] = [:]

    func start(with text: String, font: UIFont) {

        self.text = text
        self.font = font

        self.animationCurve = RollingAnimationLabelImp.easeOutBackCurve

        // These can be easily exposed for configurability
        self.totalDuration = 4.0
        self.characterDuration = 1.0

        self.displayLink = CADisplayLink(target: self, selector: #selector(tick))

        construct()

        displayLink.add(to: .main, forMode: .common)
    }

    private func construct() {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = false

        // Break the label up into one label for each character
        let characters = text.map { element in element }

        self.characterViews = characters.map(RollingAnimationLabelImp.characterView(self))

        // Use sizeThatFits to get the size of each character label, then accumulate the sizes to build frames left-to-right
        let sizes = characterViews.map { characterView in characterView.sizeThatFits(.zero) }
        let frames = sizes.map { size in CGRect(origin: .zero, size: size) }.reduce(into: [], { frames, next in frames.append(CGRect(origin: CGPoint(x: frames.last?.maxX ?? 0.0, y: 0.0), size: next.size))})

        // Now get the center of each character
        let centers = frames.map { frame in frame.center }
        let viewsAndCenters = zip(characterViews, centers)

        // The width of the entire label is the right edge of the last frame
        let width = frames.last?.maxX ?? 0.0
        let height = self.font.lineHeight

        let containerCenter = CGPoint(x: width / 2.0, y: height / 2.0)

        // Build constraints from the center of each label's calculated frame to the center of the container.  The center will be the "anchor" during the animation
        let xCharacterConstraints = viewsAndCenters.map { view, center in view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: center.x - containerCenter.x) }
        self.characterConstraints = [UILabel: NSLayoutConstraint](uniqueKeysWithValues: zip(characterViews, xCharacterConstraints))

        // Store the constant of each constraint for its "actual" position in the label, which is where it will be at the end of the animation
        self.xFinalOffsets = [UILabel: CGFloat](uniqueKeysWithValues: zip(characterViews, xCharacterConstraints.map { constraint in constraint.constant }))

        let yCharacterConstraints = viewsAndCenters.map { view, center in view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: center.y - containerCenter.y) }

        let allConstraints = [NSLayoutConstraint]([xCharacterConstraints, yCharacterConstraints].joined())

        self.addConstraints(allConstraints)

        let sizeConstraints = [self.widthAnchor.constraint(equalToConstant: width),
                               self.heightAnchor.constraint(equalToConstant: height)]

        self.addConstraints(sizeConstraints)

        // No need to animate whitespace character, no one would know the difference!
        let nonwhiteSpaceCharacterViews = characterViews.filter { label in !label.text!.first!.isWhitespace }

        // The last character's animation should end at the end of the total duration.  Therefore the last character should begin its animation at this duration minus the individual character duration.  The start times are then evenly spread between 0 and this maximum interval
        let lastAnimationStart = totalDuration - characterDuration
        let lastIndex = nonwhiteSpaceCharacterViews.count - 1
        let startTimes = (0...lastIndex).map { index in CFTimeInterval(index) * CFTimeInterval(lastAnimationStart) / CFTimeInterval(lastIndex) }

        self.startTimes = [UILabel: CFTimeInterval](uniqueKeysWithValues: zip(nonwhiteSpaceCharacterViews, startTimes))
    }

    private func characterView(_ character: Character) -> UILabel {

        let characterView = UILabel()
        characterView.translatesAutoresizingMaskIntoConstraints = false
        characterView.text = String(character)
        characterView.font = font

        self.addSubview(characterView)

        return characterView
    }

    @objc private func tick() {

        // CADisplayLink returns Mach time, and we need a point of reference, so we have to let one frame go by to define the start frame
        guard let startTime = self.startTime else {
            self.startTime = displayLink.targetTimestamp
            return
        }

        let frameTime = displayLink.targetTimestamp

        let offset = frameTime - startTime

        if offset > totalDuration {

            // The animation is completed.  Remove the display link so it doesn't keep this object alive
            self.displayLink.invalidate()
            return
        }

        // Map each offset within the duration to the offset relative to the current time.  Then scale by the character duration, and we get an array of progresses (from 0 to 1) of each character animation
        let characterOffsets = self.startTimes.mapValues { startTime in offset - startTime }
        let characterProgresses = characterOffsets.mapValues { offset in min(max(offset / self.characterDuration, 0.0), 1.0) }

        for (view, progress) in characterProgresses {

            // The animation consists of three parts: a linear alpha fade-in, a quadratic font scaling, and a reverse linear approach into the final position.
            let alpha = CGFloat(progress)
            let fontSize = self.font.pointSize * CGFloat(animationCurve(progress))

            // The constraint constants will be scaled, starting at twice their final value.  The reason we picked the center of the container as the anchor is so that the characters on the left come in from the left, and the characters on the right come in from the right
            let xFinalOffset = xFinalOffsets[view]!
            let xOffset = CGFloat(2.0 - progress) * xFinalOffset
            characterConstraints[view]!.constant = xOffset

            // One way to fake font scaling is with transforms, but this gives better results, because it actually transitions smoothly through each font size
            let font = self.font.withSize(fontSize)

            view.alpha = alpha
            view.font = font
        }

        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    // This is a quadratic function chosen to start at 0, end at 1, and spring up to 2 at 75% progress
    private static var easeOutBackCurve: (CFTimeInterval) -> CFTimeInterval = {

        { (x: CFTimeInterval) in

            CFTimeInterval(-20.0/3.0*x*x + 23.0/3.0*x)
        }
    }()
}
