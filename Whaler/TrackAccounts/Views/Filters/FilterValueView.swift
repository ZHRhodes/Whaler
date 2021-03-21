//
//  FilterValueView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/11/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

protocol FilterValueViewDelegate: class {
  func removeTapped(sender: FilterValueView)
}

class FilterValueView: UIView {
  weak var delegate: FilterValueViewDelegate?
  private(set) var filter: FilterOption!
  
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
  
  func configure(with filter: FilterOption) {
    self.filter = filter
    label.text = "\(filter.group.rawValue): \(filter.name)"
    backgroundColor = filter.group.color
  }
  
  private func configure() {
    layer.cornerRadius = 24.0
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
    delegate?.removeTapped(sender: self)
  }
}
