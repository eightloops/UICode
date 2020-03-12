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


class CallbackTests: XCTestCase {
  
  class TestView {
    var count = 0
    let onTap = Callback()
    
    init() {
      TestView.objectCounter += 1
    }
    
    deinit {
      TestView.objectCounter -= 1
    }
    
    static var objectCounter = 0
  }
  
  
  func testCallback() {
    autoreleasepool {
      XCTAssertEqual( TestView.objectCounter, 0)
      let view = TestView()
      XCTAssertEqual( TestView.objectCounter, 1)
      
      view.onTap.do(owner: view) { v in
        v.count += 1
      }
      
      view.onTap.run()
      view.onTap.run()
      XCTAssertEqual( view.count, 2)
    }
    XCTAssertEqual( TestView.objectCounter, 0)
  }
  
  class TestViewP1 {
    var count = 0
    let onTap = CallbackP1<TestView>()
    
    init() {
      TestViewP1.objectCounter += 1
    }
    
    deinit {
      TestViewP1.objectCounter -= 1
    }
    
    static var objectCounter = 0
  }
  

  func testCallbackP1() {
    autoreleasepool {
      XCTAssertEqual( TestViewP1.objectCounter, 0)
      let view1 = TestViewP1()
      let view2 = TestView()
      XCTAssertEqual( TestViewP1.objectCounter, 1)
      
      view1.onTap.do(owner: view1) { v1, v2 in
        v1.count += 1
      }
      
      view1.onTap.run( view2)
      view1.onTap.run( view2)
      XCTAssertEqual( view1.count, 2)
    }
    XCTAssertEqual( TestViewP1.objectCounter, 0)
  }
}
