//
// Copyright (c) 2014 eightloops GmbH (http://www.eightloops.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


import UIKit


public enum LayoutEdgeAttribute {
  case Top
  case Right
  case Bottom
  case Left
  
  func layoutAttribute() -> NSLayoutAttribute {
    switch self {
    case .Top:     return .Top
    case .Right:   return .Trailing
    case .Bottom:  return .Bottom
    case .Left:    return .Leading
    }
  }
  
  func positionAttribute() -> LayoutPositionAttribute {
    switch self {
    case .Top:    return .Top
    case .Right:  return .Right
    case .Bottom: return .Bottom
    case .Left:   return .Left
    }
  }
  
  func inverse() -> LayoutEdgeAttribute {
    switch self {
    case .Top:    return .Bottom
    case .Right:  return .Left
    case .Bottom: return .Top
    case .Left:   return .Right
    }
  }
}

public enum LayoutPositionAttribute {
  case Left
  case Right
  case Top
  case Bottom
  case Leading
  case Trailing
  case CenterX
  case CenterY
  
  case Baseline
  case FirstBaseline
  
  case LeftMargin
  case RightMargin
  case TopMargin
  case BottomMargin
  case LeadingMargin
  case TrailingMargin
  case CenterXWithinMargins
  case CenterYWithinMargins
  
  func layoutAttribute() -> NSLayoutAttribute {
    switch self {
    case .Top:      return .Top
    case .Right:    return .Trailing
    case .Bottom:   return .Bottom
    case .Left:     return .Leading
    case .Leading:  return .Leading
    case .Trailing: return .Trailing
    case .CenterX:  return .CenterX
    case .CenterY:  return .CenterY
      
    case .Baseline:      return .Baseline
    case .FirstBaseline: return .FirstBaseline
      
    case .LeftMargin:           return .LeftMargin
    case .RightMargin:          return .RightMargin
    case .TopMargin:            return .TopMargin
    case .BottomMargin:         return .BottomMargin
    case .LeadingMargin:        return .LeadingMargin
    case .TrailingMargin:       return .TrailingMargin
    case .CenterXWithinMargins: return .CenterXWithinMargins
    case .CenterYWithinMargins: return .CenterYWithinMargins
    }
  }
  
  func edgeAttribute() -> LayoutEdgeAttribute? {
    switch self {
    case .Top:    return .Top
    case .Right:  return .Right
    case .Bottom: return .Bottom
    case .Left:   return .Left
    default: return nil
    }
  }
}

public enum LayoutSizeAttribute {
  case Width
  case Height
  
  func layoutAttribute() -> NSLayoutAttribute {
    switch self {
    case .Width:  return .Width
    case .Height: return .Height
    }
  }
}

public enum LayoutIntrinsicSizeAttribute {
  case IntrinsicWidth
  case IntrinsicHeight
  case IntrinsicSize
}

public enum LayoutDirection {
  case Horizontal
  case Vertical
}


extension UIView {
  
  
  // pin fraction
  
  public func pin( edge: LayoutEdgeAttribute, to: UIView? = nil, insetFraction: CGFloat, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> NSLayoutConstraint {
    
    var toAttr: NSLayoutAttribute = .NotAnAttribute
    switch edge {
    case .Left:
      toAttr = .CenterX
    case .Top:
      toAttr = .CenterY
    case .Right, .Bottom:
      toAttr = edge.layoutAttribute()
    }
    
    var multiplier: CGFloat = 1.0
    switch edge {
    case .Left, .Top:
      multiplier = insetFraction * 2.0
    case .Right, .Bottom:
      multiplier = 1.0 / (1.0 - insetFraction)
    }
    
    var first = self
    var second = to ?? self.superview!
    let attr = edge.positionAttribute()
    if edge == .Right || edge == .Bottom {
      return second.pin( attr, to: first, toAttr: toAttr, constant: 0.0, multiplier: multiplier, relation: relation, priority: priority, container: container)
    } else {
      return first.pin( attr, to: second, toAttr: toAttr, constant: 0.0, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  public func pin( edges: [LayoutEdgeAttribute], to: UIView? = nil, insetFraction: CGFloat, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> [NSLayoutConstraint] {
    
    return edges.map() { (edge) in
      return self.pin( edge, to: to, insetFraction: insetFraction, relation: relation, priority: priority, container: container)
    }
  }
  
  
  // pin position
  
  public func pin( edge: LayoutEdgeAttribute, to: UIView? = nil, inset: CGFloat, multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> NSLayoutConstraint {
    
    let container = containerForView( to, container: container)
    
    var first = self
    var second = to ?? self.superview!
    let attr = edge.positionAttribute()
    if edge == .Right || edge == .Bottom {
      return second.pin( attr, to: first, constant: inset, multiplier: multiplier, relation: relation, priority: priority, container: container)
    } else {
      return first.pin( attr, to: second, constant: inset, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  public func pin( attr: LayoutPositionAttribute, to: UIView? = nil, toAttr: NSLayoutAttribute? = nil, constant: CGFloat, multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> NSLayoutConstraint {
    
    let second = to ?? self.superview!
    let secondAttr = toAttr ?? attr.layoutAttribute()
    let constraint = NSLayoutConstraint(item: self, attribute: attr.layoutAttribute(), relatedBy: relation, toItem: second, attribute: secondAttr, multiplier: multiplier, constant: constant)
    constraint.priority = priority
    constraint.addToView( view: containerForView( to, container: container))
    return constraint
  }
  
  public func pin( attr: LayoutPositionAttribute, to: UIView? = nil, toAttr: NSLayoutAttribute? = nil, multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> NSLayoutConstraint {
    if let edge = attr.edgeAttribute() {
      if toAttr == nil || toAttr == attr.layoutAttribute() && multiplier == 1.0 {
        return pin( edge, to: to, inset: 0.0, multiplier: multiplier, relation: relation, priority: priority, container: container)
      }
    }
    return pin( attr, to: to, toAttr: toAttr, constant: 0.0, multiplier: multiplier, relation: relation, priority: priority, container: container)
  }
  
  
  // pin multiple positions
  
  public func pin( edges: [LayoutEdgeAttribute], to: UIView? = nil, inset: CGFloat, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> [NSLayoutConstraint] {
    return edges.map() { (edge) in
      return self.pin( edge, to: to, inset: inset, relation: relation, priority: priority, container: container)
    }
  }
  
  public func pin( attrs: [LayoutPositionAttribute], to: UIView? = nil, constant: CGFloat, multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> [NSLayoutConstraint] {
    return attrs.map() { (attr) in
      return self.pin( attr, to: to, toAttr: attr.layoutAttribute(), constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  public func pin( attrs: [LayoutPositionAttribute], to: UIView? = nil, multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> [NSLayoutConstraint] {
    return attrs.map() { (attr) in
      return self.pin( attr, to: to, toAttr: attr.layoutAttribute(), multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  
  // pin size
  
  public func pin( attr: LayoutSizeAttribute, constant: CGFloat, multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> NSLayoutConstraint {
    let constraint = NSLayoutConstraint(item: self, attribute: attr.layoutAttribute(), relatedBy: relation, toItem: nil, attribute: attr.layoutAttribute(), multiplier: multiplier, constant: constant)
    constraint.priority = priority
    constraint.addToView( view: container)
    return constraint
  }
  
  public func pin( attr: LayoutSizeAttribute, multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> NSLayoutConstraint {
    return pin( attr, to: self.superview!, toAttr: attr.layoutAttribute(), constant: 0.0, multiplier: multiplier, relation: relation, priority: priority, container: container ?? self.superview)
  }
  
  public func pin( attr: LayoutSizeAttribute, to: UIView, toAttr: NSLayoutAttribute? = nil, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> NSLayoutConstraint {
    
    let secondAttr = toAttr ?? attr.layoutAttribute()
    let constraint = NSLayoutConstraint(item: self, attribute: attr.layoutAttribute(), relatedBy: relation, toItem: to, attribute: secondAttr, multiplier: multiplier, constant: constant)
    constraint.priority = priority
    constraint.addToView( view: containerForView( to, container: container))
    return constraint
  }
  
  
  // pin multiple sizes
  
  public func pin( attrs: [LayoutSizeAttribute], constant: CGFloat, multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> [NSLayoutConstraint] {
    return attrs.map() { (attr) in
      return self.pin( attr, constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  public func pin( attrs: [LayoutSizeAttribute], multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> [NSLayoutConstraint] {
    return attrs.map() { (attr) in
      return self.pin( attr, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  public func pin( attrs: [LayoutSizeAttribute], to: UIView, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000, container: UIView? = nil) -> [NSLayoutConstraint] {
    return attrs.map() { (attr) in
      return self.pin( attr, to: to, toAttr: attr.layoutAttribute(), constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  
  // unpin position
  
  public func unpin( attr: LayoutPositionAttribute, from: UIView? = nil, fromAttr: NSLayoutAttribute? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil, relation: NSLayoutRelation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    let firstAttribute = attr.layoutAttribute()
    let secondAttribute = fromAttr ?? firstAttribute
    let secondView = from ?? self.superview!
    
    return unpinMultiConstraint( firstAttribute, secondView: secondView, secondAttribute: secondAttribute, constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: containerForView( from, container: container))
  }
  
  
  // unpin multiple positions
  
  public func unpin( attrs: [LayoutPositionAttribute], from: UIView? = nil, fromAttr: NSLayoutAttribute? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil, relation: NSLayoutRelation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    for attr in attrs {
      for constraint in unpin( attr, from: from, fromAttr: fromAttr, constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container) {
        constraints.append( constraint)
      }
    }
    return constraints
  }
  
  
  // unpin size
  
  public func unpin( attr: LayoutSizeAttribute, from: UIView, fromAttr: NSLayoutAttribute? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil, relation: NSLayoutRelation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    let firstAttribute = attr.layoutAttribute()
    let secondAttribute = fromAttr ?? firstAttribute
    let secondView = from
    
    return unpinMultiConstraint( firstAttribute, secondView: secondView, secondAttribute: secondAttribute, constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container)
  }
  
  public func unpin( attr: LayoutSizeAttribute, multiplier: CGFloat? = nil, relation: NSLayoutRelation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    return unpin( attr, from: self.superview!, fromAttr: attr.layoutAttribute(), multiplier: multiplier, relation: relation, priority: priority, container: container ?? self.superview)
  }
  
  public func unpin( attr: LayoutSizeAttribute, constant: CGFloat?, multiplier: CGFloat? = nil, relation: NSLayoutRelation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    let firstAttribute = attr.layoutAttribute()
    
    var constraints = [NSLayoutConstraint]()
    let container = container ?? self
    for c in container.constraints() as [NSLayoutConstraint] {
      if c.firstItem as UIView == self && c.firstAttribute == firstAttribute {
        var match = true
        
        if let constant = constant {
          match = match && (constant == c.constant)
        }
        if let multiplier = multiplier {
          match = match && (multiplier == c.multiplier)
        }
        if let relation = relation {
          match = match && (relation == c.relation)
        }
        if let priority = priority {
          match = match && (priority == c.priority)
        }
        
        if match {
          constraints.append( c)
          c.removeFromView( view: container)
        }
      }
    }
    return constraints
  }
  
  
  // unpin multiple sizes
  
  public func unpin( attrs: [LayoutSizeAttribute], from: UIView, fromAttr: NSLayoutAttribute? = nil, multiplier: CGFloat? = nil, relation: NSLayoutRelation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    for attr in attrs {
      for constraint in unpin( attr, from: from, fromAttr: fromAttr, multiplier: multiplier, relation: relation, priority: priority, container: container) {
        constraints.append( constraint)
      }
    }
    return constraints
  }
  
  public func unpin( attrs: [LayoutSizeAttribute], multiplier: CGFloat? = nil, relation: NSLayoutRelation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    for attr in attrs {
      for constraint in unpin( attr, multiplier: multiplier, relation: relation, priority: priority, container: container) {
        constraints.append( constraint)
      }
    }
    return constraints
  }
  
  public func unpin( attrs: [LayoutSizeAttribute], constant: CGFloat?, multiplier: CGFloat? = nil, relation: NSLayoutRelation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    for attr in attrs {
      for constraint in unpin( attr, constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container) {
        constraints.append( constraint)
      }
    }
    return constraints
  }
  
  
  // pin helper methods
  
  func containerForView( view: UIView?, container: UIView?) -> UIView? {
    if let container = container {
      return container
    } else if view == nil {
      return self.superview
    } else {
      return nil
    }
  }
  
  func unpinMultiConstraint( firstAttribute: NSLayoutAttribute, secondView: UIView, secondAttribute: NSLayoutAttribute, constant: CGFloat? = nil, multiplier: CGFloat? = nil, relation: NSLayoutRelation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    
    let firstView = self
    var constraints: [NSLayoutConstraint] = []
    var container: UIView? = container
    if container == nil {
      container = firstView.lowestCommonAncestor( secondView)
    }
    if let container = container {
      for c in container.constraints() as [NSLayoutConstraint] {
        let firstItem = c.firstItem as UIView
        let secondItem = c.secondItem as UIView?
        
        var match = false
        
        if firstItem == firstView && secondItem == secondView {
          match = c.firstAttribute == firstAttribute && c.secondAttribute == secondAttribute
        } else if secondItem == firstView && firstItem == secondView {
          match = c.firstAttribute == secondAttribute && c.secondAttribute == firstAttribute
        }
        
        if match {
          if let constant = constant {
            match = match && (constant == c.constant)
          }
          if let multiplier = multiplier {
            match = match && (multiplier == c.multiplier)
          }
          if let relation = relation {
            match = match && (relation == c.relation)
          }
          if let priority = priority {
            match = match && (priority == c.priority)
          }
          if match {
            constraints.append( c)
            c.removeFromView( view: container)
          }
        }
      }
    }
    return constraints
  }
  
  
  public func pin( type: LayoutIntrinsicSizeAttribute, relation: NSLayoutRelation = .Equal, priority: UILayoutPriority = 1000) {
    var axes = [UILayoutConstraintAxis]()
    if type == .IntrinsicHeight || type == .IntrinsicSize {
      axes.append( .Vertical)
    }
    if type == .IntrinsicWidth || type == .IntrinsicSize {
      axes.append( .Horizontal)
    }
    if relation == .Equal || relation == .GreaterThanOrEqual {
      for axis in axes {
        self.setContentCompressionResistancePriority( priority, forAxis: axis)
      }
    }
    if relation == .Equal || relation == .LessThanOrEqual {
      for axis in axes {
        self.setContentHuggingPriority( priority, forAxis: axis)
      }
    }
  }
  
  public func tie( direction: LayoutDirection, views: [UIView], relation: NSLayoutRelation = .Equal, space: CGFloat = 0.0, priority: UILayoutPriority = 1000, install: Bool = true) -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    let viewAttr: LayoutPositionAttribute = direction == .Vertical ? .Top : .Left
    let lastAttr: NSLayoutAttribute = direction == .Vertical ? .Bottom : .Right
    var last: UIView? = nil
    for view in views {
      if let last = last {
        var container: UIView? = nil
        if install {
          container = self
        }
        let constraint = view.pin( viewAttr, to: last, toAttr: lastAttr, constant: space, relation: relation, priority: priority, container: container)
        constraints.append( constraint)
      }
      last = view
    }
    return constraints
  }
  
  public func tieSubviews( direction: LayoutDirection, space: CGFloat = 0.0, priority: UILayoutPriority = 1000) -> [NSLayoutConstraint] {
    return tie( direction, views: self.subviews as [UIView], space: space, priority: priority)
  }
}
