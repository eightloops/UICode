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

extension UIColor {
  
  public var debugValues: String {
    let (r, g, b, a) = self.rgb()
    let (red, green, blue, alpha) = (round(r * 255), round(g * 255), round(b * 255), a)
    if red == green && green == blue {
      return "White( \(red), \(alpha))"
    } else {
      return "RGBA( \(red), \(green), \(blue), \(alpha))"
    }
  }
  
  public func hsb() -> (hue:CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
    var h : CGFloat = 0, s : CGFloat = 0, b : CGFloat = 0, a : CGFloat = 0
    getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return (hue: h, saturation: s, brightness: b, alpha: a)
  }
  
  public func rgb() -> (red:CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    var r : CGFloat = 0, g : CGFloat = 0, b : CGFloat = 0, a : CGFloat = 0
    getRed( &r, green: &g, blue: &b, alpha: &a)
    return (red: r, green: g, blue: b, alpha: a)
  }
}
