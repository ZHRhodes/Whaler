//
//  CheckBox.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/10/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class CheckBox: UIView {
  var color: UIColor? {
    didSet {
      updateColors()
    }
  }
  
  var isChecked: Bool = false {
    didSet {
      fillView.alpha = isChecked ? 1.0 : 0.0
    }
  }
  
  private let fillView = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      updateColors()
  }
  
  private func configure() {
    layer.borderWidth = 2.0
    layer.cornerRadius = 2.0
    clipsToBounds = true
    configureFillView()
  }
  
  private func configureFillView() {
    fillView.backgroundColor = color
    fillView.layer.cornerRadius = 2.0
    addAndAttach(view: fillView, attachingEdges: [.all(5)])
  }
  
  private func updateColors() {
    if let color = color {
      layer.borderColor = color.cgColor
      fillView.backgroundColor = color
    }
  }
}
