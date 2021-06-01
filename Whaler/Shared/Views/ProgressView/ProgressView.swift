//
//  ProgressView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class ProgressView: UIView {
  static func makeDefaultStyle() -> ProgressView {
    return ProgressView(colors: [.brandGreen, .brandPurple, .brandRed], lineWidth: 5)
  }
  
  var isAnimating: Bool = false {
    didSet {
      guard isAnimating != oldValue else { return }
      if isAnimating {
        self.animateStroke()
      } else {
        self.shapeLayer.removeFromSuperlayer()
        self.layer.removeAllAnimations()
      }
    }
  }
  
  private let colors: [UIColor]
  private let lineWidth: CGFloat
  
  private lazy var shapeLayer: ProgressShapeLayer = {
    return ProgressShapeLayer(strokeColor: colors.first ?? .black,
                              lineWidth: lineWidth)
  }()
  
  init(frame: CGRect, colors: [UIColor], lineWidth: CGFloat) {
    self.colors = colors
    self.lineWidth = lineWidth
    
    super.init(frame: frame)
    
    self.backgroundColor = .clear
  }
  
  convenience init(colors: [UIColor], lineWidth: CGFloat) {
    self.init(frame: .zero, colors: colors, lineWidth: lineWidth)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.width / 2
    
    let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width))
    shapeLayer.path = path.cgPath
  }
  
  private func animateStroke() {
    let startAnimation = StrokeAnimation(type: .start,
                                         beginTime: 0.25,
                                         fromValue: 0.0,
                                         toValue: 1.0,
                                         duration: 0.75)
    let endAnimation = StrokeAnimation(type: .end,
                                       fromValue: 0.0,
                                       toValue: 1.0,
                                       duration: 0.75)
    let strokeAnimationGroup = CAAnimationGroup()
    strokeAnimationGroup.duration = 1
    strokeAnimationGroup.repeatDuration = .infinity
    strokeAnimationGroup.animations = [startAnimation, endAnimation]
    
    shapeLayer.add(strokeAnimationGroup, forKey: nil)
    
    let colorAnimation = ProgressStrokeColorAnimation(colors: colors.map { $0.cgColor },
                                                      duration: strokeAnimationGroup.duration * Double(colors.count) * 0.5)
    shapeLayer.add(colorAnimation, forKey: nil)
    
    self.layer.addSublayer(shapeLayer)
  }
}
