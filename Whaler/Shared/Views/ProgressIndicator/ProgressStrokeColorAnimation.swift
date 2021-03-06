//
//  ProgressStrokeColorAnimation.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class ProgressStrokeColorAnimation: CAKeyframeAnimation {
  override init() {
    super.init()
  }
  
  init(colors: [CGColor], duration: Double) {
    super.init()
    self.keyPath = "strokeColor"
    self.values = colors
    self.duration = duration
    self.repeatCount = .greatestFiniteMagnitude
    self.timingFunction = .init(name: .easeInEaseOut)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
