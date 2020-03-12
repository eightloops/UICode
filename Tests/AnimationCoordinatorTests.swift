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

import XCTest
import UICode


class AnimationCoordinatorTests: XCTestCase {
  
  func testWithoutAnimations() {
    
    let window = UIWindow( frame: CGRect( x: 0, y: 0, width: 30, height: 20))
    let subview = UIView( frame: .zero)
    
    window.push( subview) { v in
      v.pin( [.left, .right], inset: 3)
      v.pin( .centerY)
      v.pin( .height, multiplier: 0.5)
    }
    
    window.layoutIfNeeded()
    XCTAssertEqual( subview.frame.origin.y, 5)
    
    let coordinator = AnimationCoordinator()
    coordinator.animate {
      subview.unpin( .centerY)
      subview.pin( .top)
    }
    coordinator.run( window)
    
    XCTAssertEqual( subview.frame.origin.y, 0)
  }
}
