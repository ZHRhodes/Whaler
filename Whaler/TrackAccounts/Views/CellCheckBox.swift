//
//  CellCheckBox.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/10/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

extension TrackAccountsTableCell {
  class CellCheckBox: UIView {
    private let checkbox = CheckBox()
    
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
      configureCheckBox()
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
    
    private func configureCheckBox() {
      checkbox.color = .primaryText
      addAndAttach(view: checkbox, height: 30, width: 30, attachingEdges: [.centerX(0), .centerY(0)])
    }
  }
}
