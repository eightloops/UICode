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


import Foundation

public extension NSLayoutConstraint {
  
  public func addToView( view: UIView? = nil) -> Bool {
    if let container = view {
      container.addConstraint( self)
      return true
    }
    let first = firstItem as UIView
    if let second = secondItem as? UIView {
      if let common = first.lowestCommonAncestor( second) {
        common.addConstraint( self)
        return true
      } else {
        return false
      }
    } else {
      first.addConstraint( self)
      return true
    }
  }
  
  public func removeFromView( view: UIView? = nil) -> Bool {
    if let container = view {
      container.removeConstraint( self)
      return true
    }
    var nextView: UIView?
    if let first = self.firstItem as? UIView {
      if let second = self.secondItem as? UIView {
        if let common = first.lowestCommonAncestor( second) {
          nextView = common
        }
      } else {
        nextView = first
      }
    }
    while let view = nextView {
      if contains( view.constraints() as [NSLayoutConstraint], self) {
        view.removeConstraint( self)
        return true
      }
      nextView = view.superview
    }
    return false
  }
}