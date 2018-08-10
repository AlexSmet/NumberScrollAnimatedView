
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

//TODO: Add method setValue(_ newValue: Integer
//TODO: Add non-srollable thousandth separator

class ScrollableColumn {
    enum ScrollingDirection {
        case up
        case down
    }

    var duration: CFTimeInterval = 5
    var timeOffset: CFTimeInterval = 0.2
    var scrollingDirection: ScrollingDirection = .down
    var inverseSequence: Bool = false

    fileprivate var scrollLayer: CAScrollLayer = CAScrollLayer()
    fileprivate var digitCharacter: Character!
}

class SHNumbersScrollAnimatedView: UIView {

    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var textColor: UIColor = .black

    fileprivate let animationKey = "NumbersScrollAnimated"
    private(set) var scrollableColumns: [ScrollableColumn] = []

    public var value: Int = 0 {
        didSet {
            numbersText.removeAll()
            "\(value)".forEach { numbersText.append(String($0)) }
            prepareAnimations()
        }
    }
    private var numbersText: [String] = [] // get only
    public var minLength: Int = 0
    public func setValue(_ value: Int, animated: Bool) {

    }

    public func startAnimation() {
        createContentForColumns()
        createAnimations()
    }

    public func stopAnimation() {
        scrollableColumns.forEach { $0.scrollLayer.removeAnimation(forKey: animationKey)}
    }

    fileprivate func prepareAnimations() {
        scrollableColumns.forEach { $0.scrollLayer.removeFromSuperlayer() }
        scrollableColumns.removeAll()

        createScrollColumns()
    }

    fileprivate func createScrollColumns() {
        let width: CGFloat = (frame.width / CGFloat(numbersText.count)).rounded()
        let height: CGFloat = frame.height

        for (index, _) in numbersText.enumerated() {
            let newColumn = ScrollableColumn()
            newColumn.scrollLayer.frame = CGRect(x: CGFloat(index)*width , y: 0, width: width, height: height)
            scrollableColumns.append(newColumn)
            layer.addSublayer(newColumn.scrollLayer)
        }
    }

    fileprivate func createContentForColumns() {
        for (index, _) in numbersText.enumerated() {
            let aColumn = scrollableColumns[index]
            let numberText = numbersText[index]
            createContentForColumn(aColumn, withNumberText: numberText)
        }
    }

    fileprivate func createContentForColumn(_ aColumn: ScrollableColumn, withNumberText numberText: String) {
        let number = Int(numberText)!
        var textForScroll = [String]()

        var firstNumber: Int
        var lastNumber: Int
        var by: Int = 1

        // Scrolling starts from 0, by default. But when a target value is 0, than we can start scrolling from 1 or 9 (depends on the values of scrollingDirection and inverseSequence)
        switch aColumn.scrollingDirection {
        case .up:
            lastNumber = number
            if aColumn.inverseSequence {
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
            if aColumn.inverseSequence {
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
        aColumn.scrollLayer.sublayers?.removeAll()

        switch aColumn.scrollingDirection {
        case .down:
            height = 0
        case .up:
            height = -aColumn.scrollLayer.frame.height * CGFloat(textForScroll.count-1)
        }

        textForScroll.forEach {
            let textLayer = createTextLayer(withText: $0)
            textLayer.frame = CGRect(x: 0, y: height, width: aColumn.scrollLayer.frame.width, height: aColumn.scrollLayer.frame.height)
            aColumn.scrollLayer.addSublayer(textLayer)
            height += aColumn.scrollLayer.frame.height
        }
    }

    fileprivate func createTextLayer(withText: String) -> CATextLayer {
        let newLayer = CATextLayer()

        newLayer.font = font
        newLayer.fontSize = font.pointSize
        newLayer.foregroundColor = textColor.cgColor
        newLayer.alignmentMode = kCAAlignmentCenter
        newLayer.string = withText

        return newLayer
    }

    fileprivate func createAnimations() {
        for column in scrollableColumns.sorted(by: { $0.timeOffset > $1.timeOffset }) {
            createBeginAnimationForColumn(column)
            createMainAnimationForColumn(column)
        }
    }

    fileprivate func createBeginAnimationForColumn(_ column: ScrollableColumn) {
        let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
        animation.duration = column.timeOffset
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = getStartPositionYForAnimation(column: column)
        animation.toValue = (animation.fromValue as! CGFloat)

        column.scrollLayer.add(animation, forKey: animationKey + ".clearing")
    }

    fileprivate func createMainAnimationForColumn(_ column: ScrollableColumn) {
        let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
        animation.beginTime = CACurrentMediaTime() + column.timeOffset
        animation.duration = column.duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = getStartPositionYForAnimation(column: column)
        animation.toValue = 0

        column.scrollLayer.add(animation, forKey: animationKey)
    }

    fileprivate func getStartPositionYForAnimation(column : ScrollableColumn) -> CGFloat {
        var result: CGFloat

        let startOffsetY =  column.scrollLayer.frame.height
        switch column.scrollingDirection {
        case .down:
            let maxY: CGFloat = (column.scrollLayer.sublayers?.last?.frame.origin.y)!
            result  = -maxY - startOffsetY
        case .up:
            let minY: CGFloat = (column.scrollLayer.sublayers?.first?.frame.origin.y)!
            result = -minY + startOffsetY
        }

        return result
    }
}

extension String {
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
