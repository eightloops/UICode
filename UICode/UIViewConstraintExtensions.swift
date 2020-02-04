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
  case top
  case right
  case bottom
  case left
  
  func layoutAttribute() -> NSLayoutConstraint.Attribute {
    switch self {
    case .top:     return .top
    case .right:   return .right
    case .bottom:  return .bottom
    case .left:    return .left
    }
  }
  
  func positionAttribute() -> LayoutPositionAttribute {
    switch self {
    case .top:    return .top
    case .right:  return .right
    case .bottom: return .bottom
    case .left:   return .left
    }
  }
  
  func inverse() -> LayoutEdgeAttribute {
    switch self {
    case .top:    return .bottom
    case .right:  return .left
    case .bottom: return .top
    case .left:   return .right
    }
  }
}

public enum LayoutPositionAttribute {
  case left
  case right
  case top
  case bottom
  case leading
  case trailing
  case centerX
  case centerY
  
  case firstBaseline
  case lastBaseline

  case leftMargin
  case rightMargin
  case topMargin
  case bottomMargin
  case leadingMargin
  case trailingMargin
  case centerXWithinMargins
  case centerYWithinMargins
  
  func layoutAttribute() -> NSLayoutConstraint.Attribute {
    switch self {
    case .top:      return .top
    case .right:    return .right
    case .bottom:   return .bottom
    case .left:     return .left
    case .leading:  return .leading
    case .trailing: return .trailing
    case .centerX:  return .centerX
    case .centerY:  return .centerY
      
    case .firstBaseline: return .firstBaseline
    case .lastBaseline: return .lastBaseline

    case .leftMargin:           return .leftMargin
    case .rightMargin:          return .rightMargin
    case .topMargin:            return .topMargin
    case .bottomMargin:         return .bottomMargin
    case .leadingMargin:        return .leadingMargin
    case .trailingMargin:       return .trailingMargin
    case .centerXWithinMargins: return .centerXWithinMargins
    case .centerYWithinMargins: return .centerYWithinMargins
    }
  }
  
  func edgeAttribute() -> LayoutEdgeAttribute? {
    switch self {
    case .top:    return .top
    case .right:  return .right
    case .bottom: return .bottom
    case .left:   return .left
    default: return nil
    }
  }
}

public enum LayoutSizeAttribute {
  case width
  case height
  
  func layoutAttribute() -> NSLayoutConstraint.Attribute {
    switch self {
    case .width:  return .width
    case .height: return .height
    }
  }
}

public enum LayoutIntrinsicSizeAttribute {
  case intrinsicWidth
  case intrinsicHeight
  case intrinsicSize
}

public enum LayoutDirection {
  case horizontal
  case vertical
}


public protocol LayoutConstraintItem: NSObjectProtocol {
  var superview: UIView? { get }
}

extension UIView: LayoutConstraintItem {
}

extension UILayoutGuide: LayoutConstraintItem {
  public var superview: UIView? {
    return owningView
  }
}


extension LayoutConstraintItem {
  
  
  // pin fraction
  
  @discardableResult
  public func pin( _ edge: LayoutEdgeAttribute, to: LayoutConstraintItem? = nil, fraction: CGFloat, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> NSLayoutConstraint {
    
    var toAttr: NSLayoutConstraint.Attribute = .notAnAttribute
    switch edge {
    case .left:
      toAttr = .centerX
    case .top:
      toAttr = .centerY
    case .right, .bottom:
      toAttr = edge.layoutAttribute()
    }
    
    var multiplier: CGFloat = 1.0
    switch edge {
    case .left, .top:
      multiplier = fraction * 2.0
    case .right, .bottom:
      multiplier = 1.0 / (1.0 - fraction)
    }
    
    let first = self
    let second = to ?? self.superview!
    let attr = edge.positionAttribute()
    if edge == .right || edge == .bottom {
      return second.pin( attr, to: first, toAttr: toAttr, constant: 0.0, multiplier: multiplier, relation: relation, priority: priority, container: container)
    } else {
      return first.pin( attr, to: second, toAttr: toAttr, constant: 0.0, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  public func pin( _ edges: [LayoutEdgeAttribute], to: UIView? = nil, fraction: CGFloat, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> [NSLayoutConstraint] {
    
    return edges.map() { (edge) in
      return self.pin( edge, to: to, fraction: fraction, relation: relation, priority: priority, container: container)
    }
  }
  
  
  // pin position
  
  @discardableResult
  public func pin( _ edge: LayoutEdgeAttribute, to: LayoutConstraintItem? = nil, inset: CGFloat, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> NSLayoutConstraint {
    
    let first = self
    let second = to ?? self.superview!
    let attr = edge.positionAttribute()
    if edge == .right || edge == .bottom {
      return second.pin( attr, to: first, constant: inset, multiplier: multiplier, relation: relation, priority: priority, container: container)
    } else {
      return first.pin( attr, to: second, constant: inset, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  @discardableResult
  public func pin( _ attr: LayoutPositionAttribute, to: LayoutConstraintItem? = nil, toAttr: NSLayoutConstraint.Attribute? = nil, constant: CGFloat, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> NSLayoutConstraint {
    
    let second = to ?? self.superview!
    let secondAttr = toAttr ?? attr.layoutAttribute()
    let constraint = NSLayoutConstraint(item: self, attribute: attr.layoutAttribute(), relatedBy: relation, toItem: second, attribute: secondAttr, multiplier: multiplier, constant: constant)
    constraint.priority = priority
    constraint.addToView( container)
    return constraint
  }
  
  @discardableResult
  public func pin( _ attr: LayoutEdgeAttribute, to: LayoutConstraintItem?, spacing: CGFloat, inset: CGFloat? = nil, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> NSLayoutConstraint {
    let toAttr: NSLayoutConstraint.Attribute
    if to == nil {
      toAttr = attr.layoutAttribute()
    } else {
      toAttr = attr.inverse().layoutAttribute()
    }
    let constant: CGFloat
    if let inset = inset, to == nil {
      constant = inset
    } else {
      constant = spacing
    }
    return pin( attr.positionAttribute(), to: to, toAttr: toAttr, constant: constant, relation: relation, priority: priority, container: container)
  }
  
  @discardableResult
  public func pin( _ attr: LayoutPositionAttribute, to: LayoutConstraintItem? = nil, toAttr: NSLayoutConstraint.Attribute? = nil, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> NSLayoutConstraint {
    if let edge = attr.edgeAttribute() {
      if toAttr == nil || toAttr == attr.layoutAttribute() && multiplier == 1.0 {
        return pin( edge, to: to, inset: 0.0, multiplier: multiplier, relation: relation, priority: priority, container: container)
      }
    }
    return pin( attr, to: to, toAttr: toAttr, constant: 0.0, multiplier: multiplier, relation: relation, priority: priority, container: container)
  }
  
  
  // pin multiple positions
  
  @discardableResult
  public func pin( _ edges: [LayoutEdgeAttribute], to: LayoutConstraintItem? = nil, inset: CGFloat, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> [NSLayoutConstraint] {
    return edges.map() { (edge) in
      return self.pin( edge, to: to, inset: inset, relation: relation, priority: priority, container: container)
    }
  }
  
  @discardableResult
  public func pin( _ attrs: [LayoutPositionAttribute], to: LayoutConstraintItem? = nil, constant: CGFloat, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> [NSLayoutConstraint] {
    return attrs.map() { (attr) in
      return self.pin( attr, to: to, toAttr: attr.layoutAttribute(), constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  @discardableResult
  public func pin( _ attrs: [LayoutPositionAttribute], to: LayoutConstraintItem? = nil, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> [NSLayoutConstraint] {
    return attrs.map() { (attr) in
      return self.pin( attr, to: to, toAttr: attr.layoutAttribute(), multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
}


extension UIView {
  
  // pin size
  
  @discardableResult
  public func pin( _ attr: LayoutSizeAttribute, constant: CGFloat, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> NSLayoutConstraint {
    let constraint = NSLayoutConstraint(item: self, attribute: attr.layoutAttribute(), relatedBy: relation, toItem: nil, attribute: attr.layoutAttribute(), multiplier: multiplier, constant: constant)
    constraint.priority = priority
    constraint.addToView( container)
    return constraint
  }
  
  @discardableResult
  public func pin( _ attr: LayoutSizeAttribute, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> NSLayoutConstraint {
    return pin( attr, to: self.superview!, toAttr: attr.layoutAttribute(), constant: 0.0, multiplier: multiplier, relation: relation, priority: priority, container: container ?? self.superview)
  }
  
  @discardableResult
  public func pin( _ attr: LayoutSizeAttribute, to: LayoutConstraintItem, toAttr: NSLayoutConstraint.Attribute? = nil, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> NSLayoutConstraint {
    
    let secondAttr = toAttr ?? attr.layoutAttribute()
    let constraint = NSLayoutConstraint(item: self, attribute: attr.layoutAttribute(), relatedBy: relation, toItem: to, attribute: secondAttr, multiplier: multiplier, constant: constant)
    constraint.priority = priority
    constraint.addToView( container)
    return constraint
  }
  
  
  // pin multiple sizes
  
  @discardableResult
  public func pin( _ attrs: [LayoutSizeAttribute], constant: CGFloat, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> [NSLayoutConstraint] {
    return attrs.map() { (attr) in
      return self.pin( attr, constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  @discardableResult
  public func pin( _ attrs: [LayoutSizeAttribute], multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> [NSLayoutConstraint] {
    return attrs.map() { (attr) in
      return self.pin( attr, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  @discardableResult
  public func pin( _ attrs: [LayoutSizeAttribute], to: LayoutConstraintItem, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> [NSLayoutConstraint] {
    return attrs.map() { (attr) in
      return self.pin( attr, to: to, toAttr: attr.layoutAttribute(), constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container)
    }
  }
  
  
  // unpin size
  
  @discardableResult
  public func unpin( _ attr: LayoutSizeAttribute, from: UIView, fromAttr: NSLayoutConstraint.Attribute? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil, relation: NSLayoutConstraint.Relation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    let firstAttribute = attr.layoutAttribute()
    let secondAttribute = fromAttr ?? firstAttribute
    let secondView = from
    
    return unpinMultiConstraint( firstAttribute, secondView: secondView, secondAttribute: secondAttribute, constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container)
  }
  
  @discardableResult
  public func unpin( _ attr: LayoutSizeAttribute, multiplier: CGFloat? = nil, relation: NSLayoutConstraint.Relation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    if let from = self.superview {
      return unpin( attr, from: from, fromAttr: attr.layoutAttribute(), multiplier: multiplier, relation: relation, priority: priority, container: container ?? self.superview)
    } else {
      return []
    }
  }
  
  @discardableResult
  public func unpin( _ attr: LayoutSizeAttribute, constant: CGFloat?, multiplier: CGFloat? = nil, relation: NSLayoutConstraint.Relation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    let firstAttribute = attr.layoutAttribute()
    
    var constraints = [NSLayoutConstraint]()
    let container = container ?? self
    for c in container.constraints {
      if c.firstItem as! UIView == self && c.firstAttribute == firstAttribute {
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
  
  @discardableResult
  public func unpin( _ attrs: [LayoutSizeAttribute], from: UIView, fromAttr: NSLayoutConstraint.Attribute? = nil, multiplier: CGFloat? = nil, relation: NSLayoutConstraint.Relation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    for attr in attrs {
      for constraint in unpin( attr, from: from, fromAttr: fromAttr, multiplier: multiplier, relation: relation, priority: priority, container: container) {
        constraints.append( constraint)
      }
    }
    return constraints
  }
  
  @discardableResult
  public func unpin( _ attrs: [LayoutSizeAttribute], multiplier: CGFloat? = nil, relation: NSLayoutConstraint.Relation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    for attr in attrs {
      for constraint in unpin( attr, multiplier: multiplier, relation: relation, priority: priority, container: container) {
        constraints.append( constraint)
      }
    }
    return constraints
  }
  
  @discardableResult
  public func unpin( _ attrs: [LayoutSizeAttribute], constant: CGFloat?, multiplier: CGFloat? = nil, relation: NSLayoutConstraint.Relation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    for attr in attrs {
      for constraint in unpin( attr, constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container) {
        constraints.append( constraint)
      }
    }
    return constraints
  }
  
  
  // unpin position
  
  @discardableResult
  public func unpin( _ attr: LayoutPositionAttribute, from: UIView? = nil, fromAttr: NSLayoutConstraint.Attribute? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil, relation: NSLayoutConstraint.Relation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    let firstAttribute = attr.layoutAttribute()
    let secondAttribute = fromAttr ?? firstAttribute
    if let secondView = from ?? self.superview {
      return unpinMultiConstraint( firstAttribute, secondView: secondView, secondAttribute: secondAttribute, constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: containerForView( from, container: container))
    } else {
      return []
    }
  }
  
  
  // unpin multiple positions
  
  @discardableResult
  public func unpin( _ attrs: [LayoutPositionAttribute], from: UIView? = nil, fromAttr: NSLayoutConstraint.Attribute? = nil, constant: CGFloat? = nil, multiplier: CGFloat? = nil, relation: NSLayoutConstraint.Relation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    for attr in attrs {
      for constraint in unpin( attr, from: from, fromAttr: fromAttr, constant: constant, multiplier: multiplier, relation: relation, priority: priority, container: container) {
        constraints.append( constraint)
      }
    }
    return constraints
  }
  
  
  
  // pin helper methods
  
  @discardableResult
  func containerForView( _ view: UIView?, container: UIView?) -> UIView? {
    if let container = container {
      return container
    } else if view == nil {
      return self.superview
    } else {
      return nil
    }
  }
  
  @discardableResult
  func unpinMultiConstraint( _ firstAttribute: NSLayoutConstraint.Attribute, secondView: UIView, secondAttribute: NSLayoutConstraint.Attribute, constant: CGFloat? = nil, multiplier: CGFloat? = nil, relation: NSLayoutConstraint.Relation? = nil, priority: UILayoutPriority? = nil, container: UIView? = nil) -> [NSLayoutConstraint] {
    
    let firstView = self
    var constraints: [NSLayoutConstraint] = []
    var container: UIView? = container
    if container == nil {
      container = firstView.lowestCommonAncestor( secondView)
    }
    if let container = container {
      for c in container.constraints {
        let firstItem = c.firstItem as! UIView
        let secondItem = c.secondItem as! UIView?
        
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

  

  public func pin( _ type: LayoutIntrinsicSizeAttribute, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) {
    var axes = [NSLayoutConstraint.Axis]()
    if type == .intrinsicHeight || type == .intrinsicSize {
      axes.append( .vertical)
    }
    if type == .intrinsicWidth || type == .intrinsicSize {
      axes.append( .horizontal)
    }
    if relation == .equal || relation == .greaterThanOrEqual {
      for axis in axes {
        self.setContentCompressionResistancePriority( priority, for: axis)
      }
    }
    if relation == .equal || relation == .lessThanOrEqual {
      for axis in axes {
        self.setContentHuggingPriority( priority, for: axis)
      }
    }
  }
  
  public func tie( _ direction: LayoutDirection, views: [UIView], relation: NSLayoutConstraint.Relation = .equal, space: CGFloat = 0.0, priority: UILayoutPriority = .required, install: Bool = true) -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    let viewAttr: LayoutPositionAttribute = direction == .vertical ? .top : .left
    let lastAttr: NSLayoutConstraint.Attribute = direction == .vertical ? .bottom : .right
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
  
  public func tieSubviews( _ direction: LayoutDirection, space: CGFloat = 0.0, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
    return tie( direction, views: self.subviews , space: space, priority: priority)
  }
  
  public var compat_safeAreaLayoutGuide: LayoutConstraintItem {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide
    } else {
      return self
    }
  }
}
