//
//  FilterDisplayOption.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/20/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

struct FilterDisplayOption {
  let filter: Filter
  var fieldDisplayName: String = ""
  var valueDisplayName: String
  let optionsProvider: FilterOptionsProviding?
  var color: UIColor = .brandYellow
  
  init(filter: Filter, valueDisplayName: String, optionsProvider: FilterOptionsProviding?) {
    self.filter = filter
    self.valueDisplayName = valueDisplayName
    self.optionsProvider = optionsProvider
    setFieldDisplayName(from: filter)
    setColor(from: filter)
  }
  
  private mutating func setFieldDisplayName(from filter: Filter) {
    switch filter {
    case .owner:
      fieldDisplayName = "Owner"
    case .industry:
      fieldDisplayName = "Industry"
    case .state:
      fieldDisplayName = "State"
    case .revenue:
      fieldDisplayName = "Revenue"
    case .base:
      break
    }
  }
  
  private mutating func setColor(from filter: Filter) {
    switch filter {
    case .owner:
      color = .brandYellowDark
    case .industry:
      color = .brandGreenDark
    case .state:
      color = .brandPinkDark
    case .revenue:
      color = .brandPurpleDark
    case .base:
      break
    }
  }
}
