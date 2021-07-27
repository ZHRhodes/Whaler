//
//  AccountRowValuesView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/7/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit

class AccountRowValuesView: UIView {
  static let height: CGFloat = 50
  
  init(values: [String]) {
    super.init(frame: .zero)
    configureStackView(with: values)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureStackView(with values: [String]) {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)

    values.forEach { value in
      let label = makeLabel(for: value)
      stackView.addArrangedSubview(label)
    }
    
    let constraints = [
      stackView.heightAnchor.constraint(equalToConstant: AccountRowValuesView.height),
      stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 41),
      stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func makeLabel(for value: String) -> UILabel {
    let label = UILabel()
    label.text = value
    label.textColor = .gray
    label.font = UIFont.boldSystemFont(ofSize: 15)
    return label
  }
}
