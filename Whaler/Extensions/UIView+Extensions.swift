//
//  UIView+Extensions.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/27/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  func addAndAttachToEdges(view: UIView, inset: CGFloat = 0) {
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
    
    let constraints = [
      view.leftAnchor.constraint(equalTo: leftAnchor, constant: inset),
      view.topAnchor.constraint(equalTo: topAnchor, constant: inset),
      view.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset),
      view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
}