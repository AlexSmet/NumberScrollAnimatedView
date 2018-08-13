# SHNumbersScrollAnimatedView
View for displaying integer numbers with scroll animation for each digit.

Inspired by [JTNumberScrollAnimatedView](https://github.com/jonathantribouharet/JTNumberScrollAnimatedView)

All animation parameters are random (by default).

![All random](https://user-images.githubusercontent.com/25868364/44022574-b0e17484-9ef0-11e8-8db7-3af063917cc4.gif)

Scrolling direstion is down, other parameters are random.
```swift
animatedView.scrollingDirectionRule = { (_, _) in return .down }
```
![Scrolling direction is down](https://user-images.githubusercontent.com/25868364/44022666-ec7c5dce-9ef0-11e8-86ec-a4f8c4dde949.gif)

Scrolling direstion is down, sequense is not inverted, animation duration is same for all columns.
```swift
animatedView.scrollingDirectionRule = { (_, _) in return .up }
animatedView.inverseSequenceRule = { (_, _) in return false }
animatedView.durationOffsetRule = { (_, _) in return 0 }
```
![Scrolling direction is up, sequence don't inverted,  animation duration the same for all columns](https://user-images.githubusercontent.com/25868364/44022675-f3c6981a-9ef0-11e8-8dd0-4b87f429659c.gif)
