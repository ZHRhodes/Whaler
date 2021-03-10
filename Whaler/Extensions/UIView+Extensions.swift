//
//  UIView+Extensions.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/27/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

enum EdgeConstraint {
  case left(CGFloat),
       right(CGFloat),
       top(CGFloat),
       bottom(CGFloat),
       all(CGFloat),
       centerY(CGFloat),
       centerX(CGFloat)
}

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
  
  func addAndAttach(view: UIView, height: CGFloat? = nil, width: CGFloat? = nil, attachingEdges: [EdgeConstraint]) {
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
    
    if let height = height {
      view.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    if let width = width {
      view.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    for edge in attachingEdges {
      switch edge {
      case .centerX(let constant):
        view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: constant).isActive = true
      case .centerY(let constant):
        view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: constant).isActive = true
      case .left(let constant):
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: constant).isActive = true
      case .right(let constant):
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: constant).isActive = true
      case .top(let constant):
        view.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
      case .bottom(let constant):
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constant).isActive = true
      case .all(let constant):
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: constant).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: -constant).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constant).isActive = true
      }
    }
  }
  
  func showCustomAnimatedSkeleton(crossDissolveTime: TimeInterval = 0.25) {
    let gradient = SkeletonGradient(baseColor: .lightText)
    showAnimatedGradientSkeleton(usingGradient: gradient, animation: nil, transition: .crossDissolve(crossDissolveTime))
  }
}
