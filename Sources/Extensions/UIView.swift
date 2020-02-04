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
import ObjectiveC

extension UIView {
  
  @discardableResult
  public func push<T: UIView>( _ view: T, block: (T) throws -> ()) rethrows -> T {
    view.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview( view)
    try block( view)
    return view
  }
  
  @discardableResult
  public func push<T: UIView>( _ view: T) -> T {
    return push( view, block: { (_) in () })
  }
  
  @discardableResult
  public func embed<T: UIView>( _ view: T, block: (T) throws -> ()) rethrows -> T {
    return try push( view) { (v) in
      v.pin( [.top, .left])
      v.pin( [.width, .height])
      try block( v)
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
      
      var ownCandidate: UIView? = ownChain.popLast()
      var otherCandidate: UIView? = otherChain.popLast()
      
      var result: UIView? = nil
      
      while ownCandidate != nil && ownCandidate == otherCandidate {
        result = ownCandidate
        
        ownCandidate = ownChain.popLast()
        otherCandidate = otherChain.popLast()
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
}
