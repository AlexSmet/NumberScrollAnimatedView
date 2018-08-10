
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

enum ScrollingDirection {
    case up
    case down
}

class ScrollableColumn {
    var symbol: Character = Character("0")
    private var font: UIFont
    private var textColor: UIColor
    var timeOffset: CFTimeInterval = 0
    var duration: CFTimeInterval = 5
    var durationOffset: CFTimeInterval = 0
    var scrollingDirection: ScrollingDirection = .down
    var inverseSequence: Bool = false

    let animationKey = "NumbersScrollAnimated"
    fileprivate var scrollLayer: CAScrollLayer
    private var digitCharacter: Character!

    init(withFrame frame: CGRect, forLayer superLayer: CALayer, font: UIFont, textColor: UIColor) {
        self.font = font
        self.textColor = textColor

        scrollLayer = CAScrollLayer()
        scrollLayer.frame = frame
        superLayer.addSublayer(scrollLayer)
    }

    func createAnimation(timeOffset: CFTimeInterval, duration: CFTimeInterval, durationOffset: CFTimeInterval, scrollingDirection: ScrollingDirection, inverseSequence: Bool = false) {
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

        scrollLayer.add(animation, forKey: animationKey + ".clearing")
    }

    private func addMainAnimation() {
        let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
        animation.beginTime = CACurrentMediaTime() + timeOffset
        animation.duration = duration - durationOffset
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = getStartPositionYForAnimation()
        animation.toValue = 0

        scrollLayer.add(animation, forKey: animationKey)
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

    private func createTextLayer(withText: String) -> CATextLayer {
        let newLayer = CATextLayer()

        newLayer.font = font
        newLayer.fontSize = font.pointSize
        newLayer.foregroundColor = textColor.cgColor
        newLayer.alignmentMode = kCAAlignmentCenter
        newLayer.string = withText

        return newLayer
    }
}

class SHNumbersScrollAnimatedView: UIView {

    public var value: String = ""

    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var textColor: UIColor = .black

    public var animationDuration: CFTimeInterval = 5 {
        didSet {
            scrollableColumns.forEach { $0.duration = animationDuration }
        }
    }

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
        if arc4random_uniform(3) == 0 {
            return .down
        } else {
            return .up
        }
    }

    static func randomInverse() -> Bool {
        let randomValue = arc4random_uniform(3)
        if  randomValue == 0 {
            return true
        } else {
            return false
        }
    }
}

extension String {
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    static func numericSymbolsMaxWidth(usingFont font: UIFont) -> CGFloat {
        var maxWidth:CGFloat = 0

        for symbol in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] {
            maxWidth = Swift.max(maxWidth, symbol.width(usingFont: font))
        }

        return maxWidth
    }
}
