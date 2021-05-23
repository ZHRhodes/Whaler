//
//  AssignedButton.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/22/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit


class AssignedButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  private func configure() {
    isSkeletonable = true
    translatesAutoresizingMaskIntoConstraints = false
    titleLabel?.font = .openSans(weight: .bold, size: 18)
    setTitleColor(.white, for: .normal)
    reset()
  }
  
  func setSize(_ new: CGFloat) {
    widthAnchor.constraint(equalToConstant: new).isActive = true
    heightAnchor.constraint(equalToConstant: new).isActive = true
    layer.cornerRadius = new/2
    skeletonCornerRadius = 25.0
  }
  
  func reset() {
    backgroundColor = .secondaryText
    setTitle("—", for: .normal)
  }
  
  func assigned(_ new: NameAndColorProviding) {
    setTitle(new.initials, for: .normal)
    backgroundColor = new.color
  }
}

