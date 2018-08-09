
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

    fileprivate var density: Int = 10
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
            prepareAnimations()
        }
    }
    public var minLength: Int = 0
    public func setValue(_ value: Int, animated: Bool) {

    }

    public func startAnimation() {
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
        let textValue = "\(value)"
        var numbersText: [String]

        let additionalDigits = minLength - textValue.count
        if additionalDigits > 0 {
            numbersText = [String](repeating: "0", count: additionalDigits)
        } else {
            numbersText = []
        }

        textValue.forEach { numbersText.append(String($0)) }

        let width: CGFloat = (frame.width / CGFloat(numbersText.count)).rounded()
        let height: CGFloat = frame.height

        for (index, _) in numbersText.enumerated() {
            let newColumn = ScrollableColumn()
            newColumn.scrollLayer.frame = CGRect(x: CGFloat(index)*width , y: 0, width: width, height: height)
            scrollableColumns.append(newColumn)
            layer.addSublayer(newColumn.scrollLayer)
        }

        for (index, _) in numbersText.enumerated() {
            let aColumn = scrollableColumns[index]
            let numberText = numbersText[index]
            createContentForColumn(aColumn, withNumberText: numberText)
        }
    }

    fileprivate func createContentForColumn(_ aColumn: ScrollableColumn, withNumberText numberText: String) {
        let number = Int(numberText)!
        var textForScroll = [String]()

        for index in 0..<aColumn.density {
            textForScroll.append("\((number + index) % 10)")
        }

        textForScroll.append(numberText)

        if aColumn.inverseSequence {
            textForScroll.reverse()
        }

        var height: CGFloat = 0
        textForScroll.forEach {
            let textLayer = createTextLayer(withText: $0)
            textLayer.frame = CGRect(x: 0, y: height, width: aColumn.scrollLayer.frame.width, height: aColumn.scrollLayer.frame.height)
            aColumn.scrollLayer.addSublayer(textLayer)
            height = textLayer.frame.maxY
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
            let duration: CFTimeInterval = column.duration - CFTimeInterval(scrollableColumns.count) * column.durationOffset
            let maxY: CGFloat = (column.scrollLayer.sublayers?.last?.frame.origin.y)!

            let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
            animation.duration = duration + offset
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

            if column.scrollingDirection == .down {
                animation.fromValue = -maxY
                animation.toValue = 0
            } else {
                animation.fromValue = 0
                animation.toValue = -maxY
            }

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
