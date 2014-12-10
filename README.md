UICode
======

A Swift library for rapidly building iOS user interfaces with Autolayout in code.

## Example

```swift
let view = UIView( frame: CGRect( x: 0, y: 0, width: 30, height: 20))
let subview = UIView( frame: CGRectZero)

view.push( subview) { (v) in
  v.pin( [.Left, .Right], inset: 3)
  v.pin( .CenterY)
  v.pin( .Height, multiplier: 0.5)
}

view.layoutIfNeeded()

subview.frame == CGRect( x: 3, y: 5, width: 24, height: 10)
```

