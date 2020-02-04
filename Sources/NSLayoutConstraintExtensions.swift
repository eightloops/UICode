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

extension NSLayoutConstraint {
  
  @discardableResult
  public func addToView( _ view: UIView? = nil) -> Bool {
    if let container = view {
      container.addConstraint( self)
      return true
    } else {
      self.isActive = true
      return true
    }
  }
  
  @discardableResult
  public func removeFromView( view: UIView? = nil) -> Bool {
    if let container = view {
      container.removeConstraint( self)
      return true
    } else {
      self.isActive = false
      return true
    }
  }
  
  func descriptionForItem( _ item: NSObject, attribute: NSLayoutConstraint.Attribute) -> NSString {
    var desc = item.description
    if let view = item as? UIView {
      desc = view.layoutDebugDescription()
    }
    return "\(attribute.debugDescription().uppercased) - \(desc)" as NSString
  }
  
  func relationSymbol() -> NSString {
    switch relation {
    case .equal: return "=="
    case .greaterThanOrEqual: return ">="
    case .lessThanOrEqual: return "<="
    @unknown default:
      return "(?)"
    }
  }
  
  #if DEBUG
  override public var description: String {
    get {
      if let firstItem = firstItem as? UIView {
        let firstDesc = descriptionForItem( firstItem, attribute: firstAttribute)
        var secondDesc: NSString?
        if let secondItem = secondItem as? NSObject {
          secondDesc = descriptionForItem( secondItem, attribute: secondAttribute)
        }
        let orientation = firstAttribute.orientation() == .horizontal ? "H" : "V"
        
        let c: Double = Double( self.constant)
        let description = NSString( format: "%@: %4.1f %@   %@", orientation, c, relationSymbol(), firstDesc)
        if let secondDesc = secondDesc {
          return description.appendingFormat( "  |  %@", secondDesc) as String
        } else {
          return description as String
        }
      } else {
        return super.description
      }
    }
  }
  #endif
}

