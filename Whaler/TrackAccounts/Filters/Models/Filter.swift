//
//  Filter.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/11/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

enum Filter {
  case base,
       owner(Owner),
       industry(String),
       revenue(Range<Int>),
       state(String)
  
  static let allGroups: [String] = ["base", "owner", "industry", "revenue", "state"]
  
  var group: String {
    switch self {
    case .base:
      return "base"
    case .owner:
      return "owner"
    case .industry:
      return "industry"
    case .revenue:
      return "revenue"
    case .state:
      return "state"
    }
  }
}

extension Filter: Hashable {}
