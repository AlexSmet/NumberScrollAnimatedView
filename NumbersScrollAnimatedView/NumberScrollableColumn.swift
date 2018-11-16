//
//  NumberScrollableColumn.swift
//
//
//  Created by Alexander Smetannikov on 13/08/2018.
//  Copyright © 2018 Alexander Smetannikov. All rights reserved.
//

import UIKit

public enum NumberScrollAnimationDirection {
    case up
    case down
}

class NumberScrollableColumn {
    private var font: UIFont
    private var textColor: UIColor

    var symbol: Character!

    var timeOffset: CFTimeInterval = 0
    var duration: CFTimeInterval = 5
    var durationOffset: CFTimeInterval = 0
    var scrollingDirection: NumberScrollAnimationDirection = .down
    var inverseSequence: Bool = false

    var scrollLayer: CAScrollLayer

    init(withFrame frame: CGRect, forLayer superLayer: CALayer, font: UIFont, textColor: UIColor) {
        self.font = font
        self.textColor = textColor

        scrollLayer = CAScrollLayer()
        scrollLayer.frame = frame
        superLayer.addSublayer(scrollLayer)
    }

    func createAnimation(timeOffset: CFTimeInterval, duration: CFTimeInterval, durationOffset: CFTimeInterval, scrollingDirection: NumberScrollAnimationDirection, inverseSequence: Bool = false) {
        self.timeOffset = timeOffset
        self.duration = duration
        self.durationOffset = durationOffset
        self.scrollingDirection = scrollingDirection
        self.inverseSequence = inverseSequence

        if let _ = Int(String(symbol)) {
            createContent(numericalSymbol: symbol)
            addBeginAnimation()
            addMainAnimation()
        } else {
            createContent(nonNumericalSymbol: symbol)
        }
    }

    private func addBeginAnimation() {
        let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
        animation.duration = timeOffset
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = getStartPositionYForAnimation()
        animation.toValue = (animation.fromValue as! CGFloat)

        scrollLayer.add(animation, forKey: nil)
    }

    private func addMainAnimation() {
        let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
        animation.beginTime = CACurrentMediaTime() + timeOffset
        animation.duration = duration - timeOffset - durationOffset
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = getStartPositionYForAnimation()
        animation.toValue = 0

        scrollLayer.add(animation, forKey: nil)
    }

    private func getStartPositionYForAnimation() -> CGFloat {
        var result: CGFloat

        let startOffsetY =  scrollLayer.frame.height
        switch scrollingDirection {
        case .down:
            let maxY: CGFloat = (scrollLayer.sublayers?.last?.frame.origin.y)!
            result  = -maxY - startOffsetY
        case .up:
            let minY: CGFloat = (scrollLayer.sublayers?.first?.frame.origin.y)!
            result = -minY + startOffsetY
        }

        return result
    }

    func removeAllAnimations() {
        scrollLayer.removeAllAnimations()
    }

    func removeFromSuperlayer() {
        scrollLayer.removeFromSuperlayer()
    }

    private func createContent(nonNumericalSymbol: Character) {
        let textLayer = createTextLayer(withText: String(nonNumericalSymbol))
        textLayer.frame = CGRect(x: 0, y: 0, width: scrollLayer.frame.width, height: scrollLayer.frame.height)
        scrollLayer.addSublayer(textLayer)
    }

    private func createContent(numericalSymbol: Character) {
        let number = Int(String(numericalSymbol))!
        var textForScroll = [String]()

        var firstNumber: Int
        var lastNumber: Int
        var by: Int = 1

        // Scrolling starts from 0, by default. But when a target value is 0, than we can start scrolling from 1 or 9 (depends on the values of scrollingDirection and inverseSequence)
        switch scrollingDirection {
        case .up:
            lastNumber = number
            if inverseSequence {
                by = -1
                firstNumber = 10
                if number == 0 {
                    firstNumber = 9
                }
            } else {
                firstNumber = 0
                if number == 0 {
                    firstNumber = 1
                    lastNumber = 10
                }
            }
        case .down:
            firstNumber = number
            if inverseSequence {
                by = -1
                lastNumber = 0
                if number == 0 {
                    firstNumber = 10
                    lastNumber = 1
                }

            } else {
                lastNumber = 10
                if number == 0 {
                    lastNumber = 9
                }
            }
        }

        for i in stride(from: firstNumber, through: lastNumber, by: by) {
            textForScroll.append("\(i%10)")
        }

        var height: CGFloat = 0
        scrollLayer.sublayers?.removeAll()

        switch scrollingDirection {
        case .down:
            height = 0
        case .up:
            height = -scrollLayer.frame.height * CGFloat(textForScroll.count-1)
        }

        textForScroll.forEach {
            let textLayer = createTextLayer(withText: $0)
            textLayer.frame = CGRect(x: 0, y: height, width: scrollLayer.frame.width, height: scrollLayer.frame.height)
            scrollLayer.addSublayer(textLayer)
            height += scrollLayer.frame.height
        }
    }

    private func createTextLayer(withText: String) -> VerticallyCenteredTextLayer {
        let newLayer = VerticallyCenteredTextLayer()
        let attributedString = NSAttributedString(
            string: withText,
            attributes: [
                NSForegroundColorAttributeName: textColor.cgColor,
                NSFontAttributeName: font
            ])
        newLayer.alignmentMode = kCAAlignmentCenter
        newLayer.string = attributedString

        return newLayer
    }
}


private class VerticallyCenteredTextLayer: CATextLayer {
    override open func draw(in ctx: CGContext) {
        if let attributedString = self.string as? NSAttributedString {
            let height = self.bounds.size.height
            let stringSize = attributedString.size()
            let yDiff = (height - stringSize.height) / 2

            ctx.saveGState()
            ctx.translateBy(x: 0.0, y: yDiff)
            super.draw(in: ctx)
            ctx.restoreGState()
        }
    }
}
