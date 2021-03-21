//
//  FilterOption.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/20/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct FilterOption {
  let group: FilterGroup
  let name: String
  var optionsProvider: FilterOptionsProviding?
}

extension FilterOption: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(group)
    hasher.combine(name)
  }
  
  static func == (lhs: FilterOption, rhs: FilterOption) -> Bool {
    return lhs.group == rhs.group && lhs.name == rhs.name
  }
}
