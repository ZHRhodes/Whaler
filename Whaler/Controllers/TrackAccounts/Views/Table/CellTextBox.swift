//
//  CellTextBox.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/10/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

extension TrackAccountsTableCell {
  class CellTextBox: UIView {
    private let label = UILabel()
    
    var text: String? {
      get {
        return label.text
      }
      set {
        label.text = newValue
      }
    }
    
    var textColor: UIColor? {
      get {
        return label.textColor
      }
      set {
        label.textColor = newValue
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
      configureRightLine()
      configureLabel()
    }
    
    private func configureRightLine() {
      let rightLine = UIView()
      rightLine.translatesAutoresizingMaskIntoConstraints = false
      rightLine.backgroundColor = .primaryText
      addSubview(rightLine)
      
      NSLayoutConstraint.activate([
        rightLine.widthAnchor.constraint(equalToConstant: 2.0),
        rightLine.rightAnchor.constraint(equalTo: rightAnchor),
        rightLine.topAnchor.constraint(equalTo: topAnchor),
        rightLine.bottomAnchor.constraint(equalTo: bottomAnchor),
      ])
    }
    
    private func configureLabel() {
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = .primaryText
      label.font = .openSans(weight: .regular, size: 24)
      addSubview(label)
      
      NSLayoutConstraint.activate([
        label.rightAnchor.constraint(equalTo: rightAnchor),
        label.centerYAnchor.constraint(equalTo: centerYAnchor),
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
        label.heightAnchor.constraint(equalToConstant: 33.0)
      ])
    }
  }
}
