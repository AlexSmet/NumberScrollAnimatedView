# SHNumbersScrollAnimatedView
View for displaying integer numbers with scroll animation for each digit.

Inspired by [JTNumberScrollAnimatedView](https://github.com/jonathantribouharet/JTNumberScrollAnimatedView)

All animation parameters are random (by default).

![All random](https://user-images.githubusercontent.com/25868364/44020371-5ad5a2aa-9eea-11e8-9d26-5451a60dbc4b.gif)

Scrolling direstion is down, other parameters are random.
```swift
animatedView.scrollingDirectionRule = { (_, _) in return .down }
```
![Scrolling direction is down](https://user-images.githubusercontent.com/25868364/44020429-8fd1dca8-9eea-11e8-83cc-cb11f888d2a3.gif)

Scrolling direstion is down, sequense is not inverted, animation duration is same for all columns.
```swift
animatedView.scrollingDirectionRule = { (_, _) in return .up }
animatedView.inverseSequenceRule = { (_, _) in return false }
animatedView.durationOffsetRule = { (_, _) in return 0 }
```
![Scrolling direction is up, sequence don't inverted,  animation duration the same for all columns](https://user-images.githubusercontent.com/25868364/44020484-c18fba9e-9eea-11e8-847e-37d348bb2f13.gif)

