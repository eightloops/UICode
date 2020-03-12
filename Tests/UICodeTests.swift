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

class UICodeTests: XCTestCase {
  
  func testPushAndPin() {
    let view = UIView( frame: CGRect( x: 0, y: 0, width: 30, height: 20))
    let subview = UIView( frame: .zero)
    
    view.push( subview) { v in
      v.pin( [.left, .right], inset: 3)
      v.pin( .centerY)
      v.pin( .height, multiplier: 0.5)
    }
    
    view.layoutIfNeeded()
    XCTAssertEqual( subview.frame, CGRect( x: 3, y: 5, width: 24, height: 10))
  }
  
  func testAutolayoutWithSystemAPI() {
    let view = UIView( frame: CGRect( x: 0, y: 0, width: 30, height: 20))
    let subview = UIView( frame: .zero)
    
    subview.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview( subview)
    subview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3).isActive = true
    view.rightAnchor.constraint(equalTo: subview.rightAnchor, constant: 3).isActive = true
    view.centerYAnchor.constraint(equalTo: subview.centerYAnchor).isActive = true
    subview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
    
    view.layoutIfNeeded()
    XCTAssertEqual( subview.frame, CGRect( x: 3, y: 5, width: 24, height: 10))
  }
  
  func testStackView() {
    let stackView = UIStackView( frame: CGRect( x: 0, y: 0, width: 30, height: 20))
    stackView.axis = .vertical
    stackView.alignment = .center
    let subview1 = UIView( frame: .zero)
    let subview2 = UIView( frame: .zero)

    stackView.push( subview1) { v in
      v.pin( .height, multiplier: 0.5)
      v.pin( .width)
    }
    
    stackView.push( subview2) { v in
      v.pin( .height, multiplier: 0.5)
      v.pin( .width, 20)
    }

    stackView.layoutIfNeeded()
    XCTAssertEqual( subview1.frame, CGRect( x: 0, y: 0, width: 30, height: 10))
    XCTAssertEqual( subview2.frame, CGRect( x: 5, y: 10, width: 20, height: 10))
  }
}
