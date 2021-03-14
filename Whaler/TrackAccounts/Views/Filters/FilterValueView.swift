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
  var filterType: String = "State"
  var filterValue: String = "CA"
  var color: UIColor = .brandYellow
  
  private let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  private func configure() {
    layer.cornerRadius = 24.0
    backgroundColor = color
    configureLabel()
  }
  
  private func configureLabel() {
    label.text = "\(filterType): \(filterValue)"
    label.textColor = .primaryText
    label.contentMode = .center
    addAndAttach(view: label, height: 48, attachingEdges: [.left(24), .right(-24), .top(0), .bottom(0)])
  }
}
