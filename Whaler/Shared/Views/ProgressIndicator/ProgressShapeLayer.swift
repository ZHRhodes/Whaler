//
//  ProgressShapeLayer.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class ProgressShapeLayer: CAShapeLayer {
  public init(strokeColor: UIColor, lineWidth: CGFloat) {
    super.init()
    self.strokeColor = strokeColor.cgColor
    self.lineWidth = lineWidth
    self.fillColor = UIColor.clear.cgColor
    self.lineCap = .round
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
