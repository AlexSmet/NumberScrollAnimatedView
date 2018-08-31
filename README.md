# SHNumberScrollAnimatedView
View for displaying string with scroll animation for each numerical symbol. Inspired by [JTNumberScrollAnimatedView](https://github.com/jonathantribouharet/JTNumberScrollAnimatedView)

![All random](https://user-images.githubusercontent.com/25868364/44025841-e314b52a-9ef9-11e8-98e1-fa3dd7ec95a3.gif)



Usage
---
```swift
let animatedView = SHNumberScrollAnimatedView()

// Add to superview, configure view constraints etc...

// Customize a view properties like background color, font size and color
animatedView.backgroundColor = UIColor(red: 255/255, green: 47/255, blue: 146/255, alpha: 1)
animatedView.font = UIFont.boldSystemFont(ofSize: 64)
animatedView.textColor = .white

// Set or change animation properties
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
- `animationTimeOffsetRule`, specifies the offset of the animation start time for each numerical symbol. By default the function return random values from 0 to 1.
- `animationDurationOffsetRule`, specifies the change in animation duration for each numerical symbol. By default the function return random values from 0 to 1.
- `scrollingDirectionRule`, specifies the animation direction (UP or DOWN) for each numerical symbol. By default the rule return random values.
- `inverseSequenceRule`, specifies whether to invert the sequence of numbers or not. By default is 0123456789, with inversion 9876543210

Animation examples
---
1. By default. All animation parameters are random.

![All random](https://user-images.githubusercontent.com/25868364/44025841-e314b52a-9ef9-11e8-98e1-fa3dd7ec95a3.gif)

2. Scrolling direction is down.
```swift
animatedView.scrollingDirectionRule = { (_, _) in return .down }
```
![Scrolling direction is down](https://user-images.githubusercontent.com/25868364/44022666-ec7c5dce-9ef0-11e8-86ec-a4f8c4dde949.gif)

3. Scrolling direstion is up, sequense is not inverted, animation duration is same for all columns.
```swift
animatedView.scrollingDirectionRule = { (_, _) in return .up }
animatedView.inverseSequenceRule = { (_, _) in return false }
animatedView.animationDurationOffsetRule = { (_, _) in return 0 }
```
![Scrolling direction is up, sequence don't inverted,  animation duration the same for all columns](https://user-images.githubusercontent.com/25868364/44022675-f3c6981a-9ef0-11e8-8dd0-4b87f429659c.gif)
