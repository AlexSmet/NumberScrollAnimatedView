[![Cocoapods](https://img.shields.io/cocoapods/v/NumberScrollAnimatedView.svg?style=flat-square)](https://cocoapods.org/pods/NumberScrollAnimatedView)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat-square)](https://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat-square)
[![Language](https://img.shields.io/badge/language-swift-orange.svg?style=flat-square)](https://swift.org/about/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](http://opensource.org/licenses/MIT)

# NumberScrollAnimatedView
Component to display string with scroll animation for each numerical symbol. Scrolling directions, animation durations and time offsets can be easily customized.

Swift 3, Swift 4 and Swift 4.2 are supported.

![All random](https://user-images.githubusercontent.com/25868364/44025841-e314b52a-9ef9-11e8-98e1-fa3dd7ec95a3.gif)

Installation
---

### CocoaPods
[CocoaPods](https://cocoapods.org) is the preffered way to add NumberScrollAnimatedView to your project.

Just add following line to your Podfile
```
pod 'NumberScrollAnimatedView'
```
Then run a `pod install` inside your terminal.

After that you can include NumberScrollAnimatedView wherever you need it with 
```
import NumberScrollAnimatedView
```

### Manually
If you don't want to use dependency manager, you can add NumberScrollAnimatedView in your project manually. 

You can do it coping "NumberScrollAnimatedView" folder with two files "NumberScrollableColumn.swift" and "NumberScrollAnimatedView.swift" to your project. 

Usage
---
```swift
let animatedView = NumberScrollAnimatedView()

// Add to superview, configure view constraints etc...

// Customize a view properties like background color, font size and color
animatedView.backgroundColor = UIColor(red: 255/255, green: 47/255, blue: 146/255, alpha: 1)
animatedView.font = UIFont.boldSystemFont(ofSize: 64)
animatedView.textColor = .white

// Set animation properties
animatedView.animationDuration = 5
animatedView.scrollingDirectionRule = { (_, columnIndex) in return (columnIndex % 2) == 0 ? .down : .up }

// Set a value which will be displayed
animatedView.text = "220-548"

// Start animation
animatedView.startAnimation()
```

Animation parameters
---
- `animationDuration`
- `animationTimeOffsetRule`, specifies the offset of the animation start time for each numerical symbol. By default this function return random values from 0 to 1.
- `animationDurationOffsetRule`, specifies the change in animation duration for each numerical symbol. By default this function return random values from 0 to 1.
- `scrollingDirectionRule`, specifies the animation direction (UP or DOWN) for each numerical symbol. By default this rule return random values.
- `inverseSequenceRule`, specifies whether to invert the sequence of numbers or not. Default sequence is 0123456789,  inverted - 9876543210

Animation examples
---
1. By default. All animation parameters are random.

![All random](https://user-images.githubusercontent.com/25868364/44025841-e314b52a-9ef9-11e8-98e1-fa3dd7ec95a3.gif)

2. Scrolling direction is down.
```swift
animatedView.scrollingDirectionRule = { (_, _) in return .down }
```
![Scrolling direction is down](https://user-images.githubusercontent.com/25868364/44022666-ec7c5dce-9ef0-11e8-86ec-a4f8c4dde949.gif)

3. Scrolling direction is up, sequence is not inverted, animation duration is the same for all columns.
```swift
animatedView.scrollingDirectionRule = { (_, _) in return .up }
animatedView.inverseSequenceRule = { (_, _) in return false }
animatedView.animationDurationOffsetRule = { (_, _) in return 0 }
```
![Scrolling direction is up, sequence don't inverted,  animation duration the same for all columns](https://user-images.githubusercontent.com/25868364/44022675-f3c6981a-9ef0-11e8-8dd0-4b87f429659c.gif)

## Author
Created by Alexander Smetannikov (alexsmetdev@gmail.com)
