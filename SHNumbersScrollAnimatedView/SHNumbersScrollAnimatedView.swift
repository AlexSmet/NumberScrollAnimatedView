
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
    var symbol: String = ""
    private var font: UIFont
    private var textColor: UIColor
    var duration: CFTimeInterval = 5
    var timeOffset: CFTimeInterval = 0
    var scrollingDirection: ScrollingDirection = .down
    var inverseSequence: Bool = false

    let animationKey = "NumbersScrollAnimated"
    private var scrollLayer: CAScrollLayer
    private var digitCharacter: Character!

    init(withFrame frame: CGRect, forLayer superLayer: CALayer, font: UIFont, textColor: UIColor) {
        self.font = font
        self.textColor = textColor

        scrollLayer = CAScrollLayer()
        scrollLayer.frame = frame
        superLayer.addSublayer(scrollLayer)
    }

    func createAnimation(duration: CFTimeInterval, timeOffset: CFTimeInterval, scrollingDirection: ScrollingDirection, inverseSequence: Bool = false) {
        self.duration = duration
        self.timeOffset = timeOffset
        self.scrollingDirection = scrollingDirection
        self.inverseSequence = inverseSequence

        createContent(withNumberText: symbol)
        addBeginAnimation()
        addMainAnimation()
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
        animation.duration = duration
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

    private func createContent(withNumberText numberText: String) {
        let number = Int(numberText)!
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

    public var value: Int = 0 {
        didSet {
            numbersText.removeAll()
            "\(value)".forEach { numbersText.append(String($0)) }
        }
    }
    private var numbersText: [String] = []

    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var textColor: UIColor = .black

    public var animationDuration: CFTimeInterval = 5 {
        didSet {
            scrollableColumns.forEach { $0.duration = animationDuration }
        }
    }

    var timeOffsetSetter: (() -> CFTimeInterval)!
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
        let width: CGFloat = (frame.width / CGFloat(numbersText.count)).rounded()
        let height: CGFloat = frame.height

        for (index, _) in numbersText.enumerated() {
            let newColumnFrame = CGRect(x: CGFloat(index)*width , y: 0, width: width, height: height)
            let newColumn = ScrollableColumn(withFrame: newColumnFrame, forLayer: layer, font: font, textColor: textColor)
            newColumn.symbol = numbersText[index]
            scrollableColumns.append(newColumn)
        }
    }

    fileprivate func createAnimations() {
        scrollableColumns.forEach {
            $0.createAnimation(
                duration: animationDuration,
                timeOffset: timeOffsetSetter(),
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
        let randomValue = arc4random_uniform(10)
        if  randomValue < 4  {
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
}
