//
//  AddTaskButton.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/29/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class AddTaskButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    layer.cornerRadius = UIConstants.boxCornerRadius
    setTitleColor(.primaryText, for: .normal)
    titleLabel?.font = .openSans(weight: .bold, size: 16)
    setTitle("ADD TASK", for: .normal)
    backgroundColor = .accentBackground
    widthAnchor.constraint(equalToConstant: 111).isActive = true
  }
}
