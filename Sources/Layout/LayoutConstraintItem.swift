//
// Copyright (c) 2014-2020 eightloops GmbH (http://www.eightloops.com)
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
  
  // MARK: -
  // MARK: Pin position
  
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
  public func pin( _ attr: LayoutEdgeAttribute, to: LayoutConstraintItem, spacing: CGFloat, relation: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required, container: UIView? = nil) -> NSLayoutConstraint {
    let toAttr = attr.inverse().layoutAttribute()
    return pin( attr.positionAttribute(), to: to, toAttr: toAttr, constant: spacing, relation: relation, priority: priority, container: container)
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
  
  // MARK: -
  // MARK: Pin multiple positions
  
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

  // MARK: -
  // MARK: Pin fraction
  
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
  

}


extension UIView {
  
  // MARK: -
  // MARK: Pin size

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
  
  // MARK: -
  // MARK: Pin multiple sizes
  
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
  
  // MARK: -
  // MARK: Pin intrinsic size
  
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

  // MARK: -
  // MARK: Unpin size
  
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
  
  // MARK: -
  // MARK: Unpin multiple sizes
  
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
  
  // MARK: -
  // MARK: Unpin position
  
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
  
  // MARK: -
  // MARK: Unpin multiple positions
  
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
  
  
  // MARK: -
  // MARK: Pin helper methods
  
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
}
