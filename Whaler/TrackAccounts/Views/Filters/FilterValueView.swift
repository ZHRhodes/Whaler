//
//  FilterValueView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/11/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class FilterValueView: UIView {
  var color: UIColor = [.brandGreenDark, .brandRedDark, .brandPinkDark, .brandYellowDark].randomElement()!
  
  private let button = UIButton()
  private let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  func setText(type: String, value: String) {
    label.text = "\(type): \(value)"
  }
  
  private func configure() {
    layer.cornerRadius = 24.0
    backgroundColor = color
    configureButton()
    configureLabel()
  }
  
  private func configureButton() {
    button.setTitle("X", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    addAndAttach(view: button, height: 18, width: 18, attachingEdges: [.left(24), .centerY(0)])
  }
  
  private func configureLabel() {
    label.textColor = .white
    label.contentMode = .center
    addAndAttach(view: label, height: 48, attachingEdges: [.left(8, equalTo: button.rightAnchor), .right(-24), .top(0), .bottom(0)])
  }
  
  @objc
  private func buttonTapped() {
    
  }
}
