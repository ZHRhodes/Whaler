//
//  UIViewController+Extensions.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/12/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit

extension UIViewController {
  func add(_ child: UIViewController) {
    addChild(child)
    view.addSubview(child.view)
    child.didMove(toParent: self)
  }
  
  func remove() {
    guard parent != nil else { return }
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
}
