
//
//  SHNumbersScrollAnimatedView.swift
//
//
//  Inspired by https://github.com/jonathantribouharet/JTNumberScrollAnimatedView
//
//  Created by Alexander Smetannikov on 07/08/2018.
//  Copyright © 2018 Alexander Smetannikov. All rights reserved.
//

import UIKit

class SHNumbersScrollAnimatedView: UIView {

    public var value: String = ""

    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var textColor: UIColor = .black
    public var animationDuration: CFTimeInterval = 5

    var timeOffsetSetter: (() -> CFTimeInterval)!
    var durationOffsetSetter: (() -> CFTimeInterval)!
    var scrollingDirectionSetter: (() -> ScrollingDirection)!
    var inverseSequenceSetter: (() -> Bool)!

    private var scrollableColumns: [ScrollableColumn] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        timeOffsetSetter = SHNumbersScrollAnimatedView.randomTimeOffsetSetter
        durationOffsetSetter = SHNumbersScrollAnimatedView.randomTimeOffsetSetter
        scrollingDirectionSetter = SHNumbersScrollAnimatedView.randomDirection
        inverseSequenceSetter = SHNumbersScrollAnimatedView.randomInverse
    }

    public func setValue(_ value: Int, animated: Bool) {

    }

    public func startAnimation() {
        prepareAnimation()
        createAnimations()
    }

    private func prepareAnimation() {
        scrollableColumns.forEach { $0.removeFromSuperlayer() }
        scrollableColumns.removeAll()

        createScrollColumns()
    }

    public func stopAnimation() {
        scrollableColumns.forEach { $0.removeAllAnimations() }
    }

    fileprivate func createScrollColumns() {
        let height: CGFloat = frame.height

        let numericSymbolWidth = String.numericSymbolsMaxWidth(usingFont: font)
        var width: CGFloat
        var xPosition: CGFloat = 0
        for character in value {
            if let _ = Int(String(character)) {
                width = numericSymbolWidth
            } else {
                width = String(character).width(usingFont: font)
            }

            let newColumnFrame = CGRect(x: xPosition , y: 0, width: width, height: height)
            let newColumn = ScrollableColumn(withFrame: newColumnFrame, forLayer: layer, font: font, textColor: textColor)
            newColumn.symbol = character
            scrollableColumns.append(newColumn)

            xPosition += width
        }

        let xOffset = (layer.bounds.width - xPosition) / 2.0
        scrollableColumns.forEach { $0.scrollLayer.position.x += xOffset }
    }

    fileprivate func createAnimations() {
        scrollableColumns.forEach {
            $0.createAnimation(
                timeOffset: timeOffsetSetter(),
                duration: animationDuration,
                durationOffset: durationOffsetSetter(),
                scrollingDirection: scrollingDirectionSetter(),
                inverseSequence: inverseSequenceSetter())
        }
    }
}

extension SHNumbersScrollAnimatedView {

    static func randomTimeOffsetSetter() -> CFTimeInterval {
        return drand48()
    }

    static func randomDirection() -> ScrollingDirection {
        if arc4random_uniform(2) == 0 {
            return .down
        } else {
            return .up
        }
    }

    static func randomInverse() -> Bool {
        let randomValue = arc4random_uniform(2)
        if  randomValue == 0 {
            return true
        } else {
            return false
        }
    }
}
