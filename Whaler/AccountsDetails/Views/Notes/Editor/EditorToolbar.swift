//
//  EditorToolbar.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/29/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

protocol EditorToolbarDelegate: class {
  func didSelect(option: EditorToolbarOption)
}

class EditorToolbar: UIView {
  private let stackView = UIStackView()
  private var options: [EditorToolbarOption] = []
  private weak var delegate: EditorToolbarDelegate?
  
  init(options: [EditorToolbarOption], delegate: EditorToolbarDelegate?) {
    super.init(frame: .zero)
    self.options = options
    self.delegate = delegate
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  private func configure() {
    layer.masksToBounds = true
    layer.cornerRadius = 10.0
    configureStackView()
  }
  
  private func configureStackView() {
    addSubview(stackView)
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    options.forEach { option in
      let button = makeToolbarButton(for: option)
      stackView.addArrangedSubview(button)
    }
    
    let constraints = [
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  func makeToolbarButton(for option: EditorToolbarOption) -> UIButton {
    let button = ToolbarButton(option: option)
    let icon = option.icon.withTintColor(.lightText)
//    button.imageEdgeInsets = UIEdgeInsets(top: 15.6, left: 12, bottom: 15.6, right: 12)
    button.setImage(icon, for: .normal)
    button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    return button
  }
  
  @objc
  private func buttonTapped(sender: ToolbarButton) {
    delegate?.didSelect(option: sender.option)
  }
}
