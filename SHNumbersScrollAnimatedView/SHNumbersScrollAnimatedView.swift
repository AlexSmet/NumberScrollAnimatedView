
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

    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var textColor: UIColor = .black
    public var duration: CFTimeInterval = 1.5
    public var durationOffset: CFTimeInterval = 0.2
    public var density: Int = 5

    fileprivate let animationKey = "NumbersScrollAnimated"
    fileprivate var scrollLayers: [CAScrollLayer] = []
    fileprivate var numbersText: [String] = []

    public var value: Int = 0 {
        didSet {
            prepareAnimations()
        }
    }
    public var minLength: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    fileprivate func commonInit() {

    }

    public func startAnimation() {
        prepareAnimations()
        createAnimations()
    }

    public func stopAnimation() {
        scrollLayers.forEach { $0.removeAnimation(forKey: animationKey)}
    }

    fileprivate func prepareAnimations() {
        scrollLayers.forEach { $0.removeFromSuperlayer() }

        numbersText.removeAll()
        scrollLayers.removeAll()

        createNumbersText()
        createScrollLayers()
    }

    fileprivate func createNumbersText() {
        let textValue = "\(value)"

        let additionalLength = minLength - textValue.count
        if additionalLength > 0 {
            numbersText = [String](repeating: "0", count: additionalLength)
        } else {
            numbersText = []
        }

        textValue.forEach { numbersText.append(String($0)) }
    }

    fileprivate func createScrollLayers() {
        let width: CGFloat = (frame.width / CGFloat(numbersText.count)).rounded()
        let height: CGFloat = frame.height

        for (index, _) in numbersText.enumerated() {
            let newLayer = CAScrollLayer()
            newLayer.frame = CGRect(x: CGFloat(index)*width , y: 0, width: width, height: height)
            scrollLayers.append(newLayer)
            layer.addSublayer(newLayer)
        }

        for (index, _) in numbersText.enumerated() {
            let aLayer = scrollLayers[index]
            let numberText = numbersText[index]
            createContentForLayer(aLayer, withNumberText: numberText)
        }
    }

    fileprivate func createContentForLayer(_ aLayer: CAScrollLayer, withNumberText numberText: String) {
        let number = Int(numberText)!
        var textForScroll = [String]()

        for index in 0..<(density+1) {
            textForScroll.append("\((number + index) % 10)")
        }

        textForScroll.append(numberText)

        var height: CGFloat = 0
        textForScroll.forEach {
            let textLayer = createTextLayer(withText: $0)
            textLayer.frame = CGRect(x: 0, y: height, width: aLayer.frame.width, height: aLayer.frame.height)
            aLayer.addSublayer(textLayer)
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
        let duration: CFTimeInterval = self.duration - CFTimeInterval(numbersText.count) * durationOffset
        var offset: CFTimeInterval = 0

        for scrollLayer in scrollLayers {
            let maxY: CGFloat = (scrollLayer.sublayers?.last?.frame.origin.y)!

            let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
            animation.duration = duration + offset
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

            animation.fromValue = -maxY
            animation.toValue = 0

            scrollLayer.add(animation, forKey: animationKey)

            offset += durationOffset
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
