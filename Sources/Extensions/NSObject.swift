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

import Foundation


extension NSObject {
  
  func className() -> String {
    var name = self.description
    if let match = self.description.range( of: "^<[_A-Za-z0-9\\.]+:", options: .regularExpression) {
      let fromIndex = name.index(after: match.lowerBound)
      let toIndex = name.index(before: match.upperBound)
      let subrange = Range(uncheckedBounds: (fromIndex, toIndex))
      name = String( self.description[subrange])
      if name.range( of: "[0-9]", options: .regularExpression) != nil {
        let parts = name.components( separatedBy: CharacterSet.decimalDigits).filter( { (s) in !s.isEmpty }) as NSArray
        let x = parts.subarray( with: NSRange( location: 1, length: parts.count - 1)) as NSArray
        name = x.componentsJoined( by: ".")
      }
    }
    return name
  }
}
