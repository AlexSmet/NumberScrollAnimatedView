class SHNumbersScrollAnimatedView: UIView {

    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var textColor: UIColor = .black
    public var duration: CFTimeInterval = 1.5
    public var durationOffset: CFTimeInterval = 0.2
    public var density: Int = 5

    fileprivate let animationKey = "NumbersScrollAnimated"
    fileprivate var scrollLayers: [CAScrollLayer] = []
    fileprivate var scrollLabels: [UILabel] = []
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
        scrollLabels.removeAll()

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
            let textLabel = createLabel(withText: $0)
            textLabel.frame = CGRect(x: 0, y: height, width: aLayer.frame.width, height: aLayer.frame.height)
            aLayer.addSublayer(textLabel.layer)
            scrollLabels.append(textLabel)
            height = textLabel.frame.maxY
        }
    }

    fileprivate func createLabel(withText: String) -> UILabel{
        let label = UILabel()

        label.textColor = textColor
        label.font = font
        label.textAlignment = .center
        label.text = withText

        return label
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
