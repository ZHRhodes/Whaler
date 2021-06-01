//
//  ProgressStrokeAnimation.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class StrokeAnimation: CABasicAnimation {
  enum StrokeType {
    case start, end
  }
  
  override init() {
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(type: StrokeType,
       beginTime: Double = 0.0,
       fromValue: CGFloat,
       toValue: CGFloat,
       duration: Double) {
    super.init()
    self.keyPath = type == .start ? "strokeStart" : "strokeEnd"
    self.beginTime = beginTime
    self.fromValue = fromValue
    self.toValue = toValue
    self.duration = duration
    self.timingFunction = .init(name: .easeInEaseOut)
  }
}
