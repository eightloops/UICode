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

public class CallbackP1<P1> {
  
  public init() {}
  
  private class CallableBlockP1<P1> {
    func run( _ p1: P1) {}
  }

  private class Block<C, P1>: CallableBlockP1<P1> where C: AnyObject {
    
    weak var owner: C?
    let block: ((C, P1) -> ())
    
    init( owner: C, block: @escaping ((C, P1) -> ())) {
      self.owner = owner
      self.block = block
    }
    
    override func run( _ p1: P1) {
      if let owner = owner {
        block( owner, p1)
      }
    }
  }
  
  private var blocks: [CallableBlockP1<P1>] = []
  
  public func `do`<C: AnyObject>( owner: C, block: @escaping (C, P1) -> ()) {
    blocks.append( Block( owner: owner, block: block))
  }
  
  public func run( _ p1: P1) {
    for block in blocks {
      block.run( p1)
    }
  }
}
