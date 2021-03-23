//
//  FilterPopoverTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/13/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class FilterPopoverTableCell: UITableViewCell {
  static let id = "FilterPopoverTableCellId"
  
  var filterDisplayOption: FilterDisplayOption? {
    didSet {
      textLabel?.text = filterDisplayOption?.valueDisplayName
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  private func configure() {
    textLabel?.textColor = .primaryText
    backgroundColor = .primaryBackground
    addGestureRecognizer(UIHoverGestureRecognizer(target: self, action: #selector(hovering(_:))))
  }
  
  @objc
  private func hovering(_ recognizer: UIHoverGestureRecognizer) {
    #if targetEnvironment(macCatalyst)
    switch recognizer.state {
    case .began, .changed:
      textLabel?.textColor = .primaryTextInverted
      backgroundColor = .primaryBackgroundInverted
    case .ended:
      textLabel?.textColor = .primaryText
      backgroundColor = .primaryBackground
    break
    default:
      break
    }
    #endif
  }
}
