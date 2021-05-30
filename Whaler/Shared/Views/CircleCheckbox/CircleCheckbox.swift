//
//  CircleCheckbox.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/25/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class CircleCheckbox: UIButton {
  let fillView = UIView()
  private let fillInset: CGFloat = 5.0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setSize(_ new: CGFloat) {
    layer.cornerRadius = new/2
    fillView.layer.cornerRadius = (new - (fillInset*2))/2
    heightAnchor.constraint(equalToConstant: new).isActive = true
    widthAnchor.constraint(equalToConstant: new).isActive = true
  }
  
  private func configure() {
    layer.borderColor = UIColor.borderLineColor.cgColor
    layer.borderWidth = 3.0
    configureFillView()
  }
  
  private func configureFillView() {
    fillView.backgroundColor = .brandPurple
    fillView.isHidden = true
    fillView.isUserInteractionEnabled = false
    addAndAttachToEdges(view: fillView, inset: fillInset)
  }
  
  func toggle() {
    fillView.isHidden = !fillView.isHidden
  }
  
  func setToggle(on: Bool) {
    fillView.isHidden = !on
  }
}
