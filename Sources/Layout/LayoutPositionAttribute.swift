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
