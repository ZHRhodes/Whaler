//
//  CurrentUserView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class CurrentUserView: UIView {
  private let label = UILabel()

  var text: String? {
    get {
      return label.text
    }
    set {
      label.text = newValue
    }
  }
  
  init() {
    super.init(frame: .zero)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  private func configure() {
    configureLabel()
  }
  
  private func configureLabel() {
    label.textColor = .white
    label.font = .openSans(weight: .bold, size: 28)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    NSLayoutConstraint.activate([
      label.leftAnchor.constraint(equalTo: leftAnchor),
      label.rightAnchor.constraint(equalTo: rightAnchor),
      label.topAnchor.constraint(equalTo: topAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
}
