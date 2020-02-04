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
import ObjectiveC

extension UIView {
  
  @discardableResult
  public func push<T: UIView>( _ view: T, block: (T) -> ()) -> T {
    view.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview( view)
    block( view)
    return view
  }
  
  @discardableResult
  public func push<T: UIView>( _ view: T) -> T {
    return push( view, block: { (_) in () })
  }
  
  @discardableResult
  public func embed<T: UIView>( _ view: T, block: (T) -> ()) -> T {
    return push( view) { (v) in
      v.pin( [.top, .left])
      v.pin( [.width, .height])
      block( v)
    }
  }
  
  @discardableResult
  public func embed<T: UIView>( _ view: T) -> T {
    return embed( view, block: { (_) in () })
  }
  
  public func lowestCommonAncestor( _ other: UIView) -> UIView? {
    let ownSuperview = self.superview as UIView?
    let otherSuperview = other.superview as UIView?
    
    if otherSuperview == self {
      return self
    } else if ownSuperview != nil && ownSuperview == other {
      return other
    } else if otherSuperview != nil && ownSuperview == otherSuperview {
      return ownSuperview
    } else {
      var ownChain = self.viewChain()
      var otherChain = other.viewChain()
      
      var ownCandidate: UIView? = ownChain.pop()
      var otherCandidate: UIView? = otherChain.pop()
      
      var result: UIView? = nil
      
      while ownCandidate != nil && ownCandidate == otherCandidate {
        result = ownCandidate
        
        ownCandidate = ownChain.pop()
        otherCandidate = otherChain.pop()
      }
      
      return result
    }
  }
  
  public func viewChain() -> [UIView] {
    var result = [UIView]()
    var current: UIView? = self
    while let _current = current {
      result.append( _current)
      current = _current.superview as UIView?
    }
    return result
  }
  
  
  public func enclosingTableView() -> UITableView? {
    var parentView = superview
    while parentView != nil {
      if let tableView = parentView as? UITableView {
        return tableView
      }
      else {
        parentView = parentView?.superview
      }
    }
    return nil
  }
  
  public func enclosingScrollView() -> UIScrollView? {
    var parentView = superview
    while parentView != nil {
      if let scrollView = parentView as? UIScrollView {
        return scrollView
      }
      else {
        parentView = parentView?.superview
      }
    }
    return nil
  }
  
  public func firstResponder() -> UIView? {
    if isFirstResponder {
      return self
    }
    
    for subview in subviews {
      if let firstResponder = subview.firstResponder() {
        return firstResponder
      }
    }
    
    return nil
  }
  
  public func logViewHierarchy() {
    logViewHierarchy( 0)
  }
  
  public func logViewHierarchy( _ indent: Int) {
    var prefix = " "
    for _ in 0..<(indent * 2) {
      prefix += " "
    }
    let address = NSString(format: "%p", self)
    var hidden = ""
    var alpha = ""
    if self.isHidden {
      hidden = " [HIDDEN]"
    } else if self.alpha < 0.1 {
      alpha = " [ALPHA=\(round(self.alpha * 100)/100)]"
    }
    var color = ""
    if let c = backgroundColor {
      color = " \(c.debugValues)"
    }
    
    print( "\(prefix)\(self.className()) (\(address)) (\(self.frame))\(hidden)\(alpha)\(color)")
    
    for view in subviews {
      view.logViewHierarchy( indent + 1)
    }
  }
  
  public func recursivelyLayoutIfNeeded() {
    for subview in subviews {
      subview.recursivelyLayoutIfNeeded()
    }
    layoutIfNeeded()
  }
  
  public func recursiveSizeToFit() {
    for view in subviews {
      view.sizeToFit()
    }
    sizeToFit()
  }
  
  @objc
  open func statusBarAppearanceDidUpdate() {
    for subview in subviews {
      subview.statusBarAppearanceDidUpdate()
    }
  }
  
  public func removeAndReaddToSuperview() {
    if let superview = self.superview {
      var constraints: [NSLayoutConstraint] = []
      for constraint in superview.constraints {
        var first, second: UIView?
        if let _first = constraint.firstItem as? UIView {
          first = _first
        }
        if let _second = constraint.secondItem as? UIView {
          second = _second
        }
        if (first == superview && second == self) || (first == self && second == superview) {
          superview.removeConstraint( constraint)
          constraints.append( constraint)
        }
      }
      let subviews = superview.subviews as NSArray
      let index = subviews.index( of: self)
      self.removeFromSuperview()
      superview.insertSubview( self, at: index)
      superview.addConstraints( constraints)
    }
  }
  
  
  public var debugName: String? {
    get {
      return objc_getAssociatedObject( self, &UIViewDebugName) as? String
    }
    set {
      objc_setAssociatedObject( self, &UIViewDebugName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  func layoutDebugDescription() -> String {
    return debugName ?? className()
  }
  
  open func hide() {
    alpha = 0.0
  }
  
  open func show() {
    alpha = 1.0
  }
  
  public var pixel: CGFloat {
    return 1.0 / (window?.screen ?? UIScreen.main).scale
  }
  
  public func wouldReceiveTouches() -> Bool {
    if let superview = self.superview, let window = window {
      let frame = superview.convert( self.frame, to: nil)
      let point = CGPoint(x: frame.origin.x + frame.width / 2.0, y: frame.origin.y + frame.height / 2.0)
      if let hitView = window.hitTest( point, with: nil) {
        if hitView == self {
          return true
        } else {
          return hitView.isDescendant( of: self)
        }
      } else {
        return false
      }
    } else {
      return false
    }
  }
}

var UIViewDebugName: UInt8 = 0
