
//
//  SHNumberScrollAnimatedView.swift
//
//
//  Inspired by https://github.com/jonathantribouharet/JTNumberScrollAnimatedView
//
//  Created by Alexander Smetannikov on 07/08/2018.
//  Copyright © 2018 Alexander Smetannikov. All rights reserved.
//

import UIKit

class SHNumberScrollAnimatedView: UIView {
    /// Displayable value, numeric symbols will display with scroll animation
    public var text: String = ""

    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var textColor: UIColor = .black
    /// Animation duration
    public var animationDuration: CFTimeInterval = 5

    public var animationTimeOffsetRule: ((_ text: String, _ index: Int) -> CFTimeInterval)!
    public var animationDurationOffsetRule: ((_ text: String, _ index: Int) -> CFTimeInterval)!
    public var scrollingDirectionRule: ((_ text: String, _ index: Int) -> NumberScrollAnimationDirection)!
    public var inverseSequenceRule: ((_ scrollableValue: String, _ forColumn: Int) -> Bool)!

    private var scrollableColumns: [NumberScrollableColumn] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        animationTimeOffsetRule = SHNumberScrollAnimatedView.randomTimeOffsetSetter
        animationDurationOffsetRule = SHNumberScrollAnimatedView.randomTimeOffsetSetter
        scrollingDirectionRule = SHNumberScrollAnimatedView.randomDirection
        inverseSequenceRule = SHNumberScrollAnimatedView.randomInverse
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
        for character in text {
            if let _ = Int(String(character)) {
                width = numericSymbolWidth
            } else {
                width = String(character).width(usingFont: font)
            }

            let newColumnFrame = CGRect(x: xPosition , y: 0, width: width, height: height)
            let newColumn = NumberScrollableColumn(withFrame: newColumnFrame, forLayer: layer, font: font, textColor: textColor)
            newColumn.symbol = character
            scrollableColumns.append(newColumn)

            xPosition += width
        }

        let xOffset = (layer.bounds.width - xPosition) / 2.0
        scrollableColumns.forEach { $0.scrollLayer.position.x += xOffset }
    }

    fileprivate func createAnimations() {
        for (index, column) in scrollableColumns.enumerated() {
            column.createAnimation(
                timeOffset: animationTimeOffsetRule(text, index),
                duration: animationDuration,
                durationOffset: animationDurationOffsetRule(text, index),
                scrollingDirection: scrollingDirectionRule(text, index),
                inverseSequence: inverseSequenceRule(text, index))
        }
    }
}

extension SHNumberScrollAnimatedView {

    static func random(_ scrollableValue: String, _ forColumn: Int) -> CFTimeInterval {
        return drand48()
    }

    static func random(_ scrollableValue: String, _ forColumn: Int) -> Bool {
        let randomValue = arc4random_uniform(2)
        if  randomValue == 0 {
            return true
        } else {
            return false
        }
    }

    static func random(_ scrollableValue: String, _ forColumn: Int) -> NumberScrollAnimationDirection {
        if arc4random_uniform(2) == 0 {
            return .down
        } else {
            return .up
        }
    }
}
