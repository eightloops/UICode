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


public class AnimationCoordinator: NSObject {
  
  var animationCurve: UIView.AnimationCurve?
  var timingFunction: CAMediaTimingFunction?
  var duration: TimeInterval = 0.3
  
  typealias Block = () -> ()
  
  var afterInitialLayoutHandlers = Queue<Block>()
  var animationHandlers = Queue<Block>()
  var afterAnimationLayoutHandlers = Queue<Block>()
  var completionHandlers = Queue<Block>()
  
  deinit {
    run()
  }
  
  public func afterInitialLayout( _ block: @escaping () -> ()) {
    afterInitialLayoutHandlers.enqueue( block)
  }
  
  public func animate( _ block: @escaping () -> ()) {
    animationHandlers.enqueue( block)
  }
  
  public func afterAnimationLayout( _ block: @escaping () -> ()) {
    afterAnimationLayoutHandlers.enqueue( block)
  }
  
  public func complete( _ block: @escaping () -> ()) {
    completionHandlers.enqueue( block)
  }
  
  func afterInitialLayout() {
    while let handler = afterInitialLayoutHandlers.dequeue() {
      handler()
    }
  }
  
  func animate() {
    while let handler = animationHandlers.dequeue() {
      handler()
    }
  }
  
  func afterAnimationLayout() {
    while let handler = afterAnimationLayoutHandlers.dequeue() {
      handler()
    }
  }
  
  func complete() {
    while let handler = completionHandlers.dequeue() {
      handler()
    }
    emptyQueues()
  }
  
  func emptyQueues() {
    for queue in [afterInitialLayoutHandlers, animationHandlers, afterAnimationLayoutHandlers, completionHandlers] {
      queue.items = []
    }
  }
  
  public func run() {
    self.runWithoutAnimations()
  }
  
  public func run( _ window: UIWindow?, animated: Bool = true) {
    if let window = window, animated {
      self.runAnimated( window)
    } else {
      self.runWithoutAnimations()
    }
  }
  
  public func runWithoutAnimations() {
    unlessStarted() {
      self.afterInitialLayout()
      self.animate()
      self.afterAnimationLayout()
      self.complete()
    }
  }
  
  public func runAnimated( _ window: UIWindow) {
    unlessStarted() {
      window.layoutIfNeeded()
      self.afterInitialLayout()
      UIView.animate( withDuration: self.duration, animations: {
        if let curve = self.animationCurve {
          UIView.setAnimationCurve( curve)
        } else if let timingFunction = self.timingFunction {
          CATransaction.setAnimationTimingFunction( timingFunction)
        }
        self.animate()
        window.layoutIfNeeded()
        self.afterAnimationLayout()
      }, completion: { (success) in
        self.complete()
      })
    }
  }
  
  var started = false
  func unlessStarted( _ runBlock: () -> ()) {
    if started {
      return
    }
    started = true
    runBlock()
  }
  
  class Queue<T> {
    var items: [T]
    
    var count: Int {
      get { return items.count }
    }
    
    init( items: [T] = []) {
      self.items = items
    }
    
    func enqueue( _ item: T) {
      items.append( item)
    }
    
    func dequeue() -> T? {
      if items.count == 0 {
        return nil
      } else {
        let item = items[0]
        items.remove( at: 0)
        return item
      }
    }
  }
}
