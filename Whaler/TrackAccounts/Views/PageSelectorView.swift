//
//  PageSelectorView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/10/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

protocol PageSelectorDelegate: class {
  func backButtonTapped()
  func forwardButtonTapped()
}

class PageSelectorView: UIView {
  weak var delegate: PageSelectorDelegate?
  private var stackView: UIStackView!
  private lazy var leftButton = makeButton(with: "<")
  private let label = UILabel()
  private lazy var rightButton = makeButton(with: ">")
  
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
    stackView = UIStackView(arrangedSubviews: [leftButton, label, rightButton])
    stackView.axis = .horizontal
    addAndAttach(view: stackView, attachingEdges: [.all(0)])
    label.textColor = .primaryText
    label.text = "1 / 6"
  }
  
  private func makeButton(with text: String) -> UIButton {
    let button = UIButton()
    button.setTitleColor(.primaryText, for: .normal)
    button.setTitle(text, for: .normal)
    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    return button
  }
  
  @objc
  private func buttonTapped(_ sender: UIButton) {
    if sender === leftButton {
      delegate?.backButtonTapped()
    } else if sender === rightButton {
      delegate?.forwardButtonTapped()
    }
  }
}
