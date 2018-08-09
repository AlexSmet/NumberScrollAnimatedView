
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

//TODO: Start animation with empty view
//TODO: Add method setValue(_ newValue: Integer
//TODO: Add non-srollable thousandth separator

class ScrollableColumn {
    enum ScrollingDirection {
        case up
        case down
    }

    var duration: CFTimeInterval = 5
    var durationOffset: CFTimeInterval = 0.2
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
            textForScroll.forEach {
                let textLayer = createTextLayer(withText: $0)
                textLayer.frame = CGRect(x: 0, y: height, width: aColumn.scrollLayer.frame.width, height: aColumn.scrollLayer.frame.height)
                aColumn.scrollLayer.addSublayer(textLayer)
                height = textLayer.frame.maxY
            }
        case .up:
            for text in textForScroll.reversed() {
                let textLayer = createTextLayer(withText: text)
                textLayer.frame = CGRect(x: 0, y: height, width: aColumn.scrollLayer.frame.width, height: aColumn.scrollLayer.frame.height)
                aColumn.scrollLayer.addSublayer(textLayer)
                height = textLayer.frame.minY - aColumn.scrollLayer.frame.height
            }
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
        var offset: CFTimeInterval = 0

        for column in scrollableColumns {
            let maxY: CGFloat = (column.scrollLayer.sublayers?.last?.frame.origin.y)!

            let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
            animation.duration = column.duration //duration + offset
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

            let startOffsetY =  column.scrollLayer.frame.height * (column.scrollingDirection == .up ? 1 : -1)
            animation.fromValue = -maxY + startOffsetY
            animation.toValue = 0

            column.scrollLayer.add(animation, forKey: animationKey)

            offset += column.durationOffset
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
