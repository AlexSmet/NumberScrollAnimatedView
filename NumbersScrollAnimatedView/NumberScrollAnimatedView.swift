
//
//  NumberScrollAnimatedView.swift
//
//
//  Inspired by https://github.com/jonathantribouharet/JTNumberScrollAnimatedView
//
//  Created by Alexander Smetannikov on 07/08/2018.
//  Copyright © 2018 Alexander Smetannikov. All rights reserved.
//

import UIKit

public class NumberScrollAnimatedView: UIView {
    /// Displayable value, numeric symbols will display with scroll animation
    public var text: String = ""

    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var textColor: UIColor = .black
    /// Animation duration
    public var animationDuration: CFTimeInterval = 5

    /**
     Custom rule specifies the offset of the animation start time for each numerical symbol.
     By default the rule return random values from 0 to 1.

     Parameters:

     **text**: displayable text

     **index**: symbol's index for which the rule will be applied

     Return an animation time offset for each symbol.
    */
    public var animationTimeOffsetRule: ((_ text: String, _ index: Int) -> CFTimeInterval)!
    /**
     Custom rule specifies the change in animation duration for each numerical symbol.
     By default the rule return random values from 0 to 1.

     Parameters:

     **text**: displayable text

     **index**: symbol's index for which the rule will be applied

     Return an animation duration time offset for each symbol.
    */
    public var animationDurationOffsetRule: ((_ text: String, _ index: Int) -> CFTimeInterval)!
    /**
     Custom rule specifies the animation direction (UP or DOWN) for each numerical symbol.
     By default the rule return random values.

     Parameters:

     **text**: displayable text

     **index**: symbol's index for which the rule will be applied

     Return an animation direction for each symbol.
    */
    public var scrollingDirectionRule: ((_ text: String, _ index: Int) -> NumberScrollAnimationDirection)!
    /**
     Custom rule specifies whether to invert the sequence of numbers or not.
     By default is 0123456789, with inversion 9876543210

     Parameters:

     **text**: displayable text

     **index**: symbol's index for which the rule will be applied

     Return bool-value
    */
    public var inverseSequenceRule: ((_ scrollableValue: String, _ forColumn: Int) -> Bool)!

    private var scrollableColumns: [NumberScrollableColumn] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        animationTimeOffsetRule = NumberScrollAnimatedView.random
        animationDurationOffsetRule = NumberScrollAnimatedView.random
        scrollingDirectionRule = NumberScrollAnimatedView.random
        inverseSequenceRule = NumberScrollAnimatedView.randomBool
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

extension NumberScrollAnimatedView {

    static func random(_ scrollableValue: String, _ forColumn: Int) -> CFTimeInterval {
        return drand48()
    }

    static func randomBool(_ scrollableValue: String, _ forColumn: Int) -> Bool {
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


private extension String {
    func size(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size
    }

    func width(usingFont font: UIFont) -> CGFloat {
        return size(usingFont: font).width
    }

    func height(usingFont font: UIFont) -> CGFloat {
        return size(usingFont: font).height
    }

    static func numericSymbolsMaxWidth(usingFont font: UIFont) -> CGFloat {
        var maxWidth:CGFloat = 0

        for symbol in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] {
            maxWidth = Swift.max(maxWidth, symbol.width(usingFont: font))
        }

        return maxWidth
    }
}
