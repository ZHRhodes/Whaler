//
//  EditorToolbar.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/29/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

class EditorToolbar: UIView {
  private let stackView = UIStackView()
  private var options: [EditorToolbarOption] = []
  
  init(options: [EditorToolbarOption]) {
    super.init(frame: .zero)
    self.options = options
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
    configureStackView()
  }
  
  private func configureStackView() {
    addSubview(stackView)
    stackView.axis = .horizontal
    
    options.forEach { option in
      let button = makeToolbarButton(for: option)
      stackView.addArrangedSubview(button)
    }
    
    let constraints = [
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.rightAnchor.constraint(equalTo: rightAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  func makeToolbarButton(for option: EditorToolbarOption) -> UIButton {
    let button = ToolbarButton(option: option)
    button.setImage(option.icon, for: .normal)
    button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    
    let constraints = [
      button.heightAnchor.constraint(equalToConstant: 20),
      button.widthAnchor.constraint(equalToConstant: 30)
    ]
    
    NSLayoutConstraint.activate(constraints)
    
    return button
  }
  
  @objc
  private func buttonTapped(sender: ToolbarButton) {
    Log.debug("Button tapped. \(sender.option)", context: .textEditor)
  }
}
