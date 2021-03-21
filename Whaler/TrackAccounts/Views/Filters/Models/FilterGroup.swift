//
//  FilterGroup.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/11/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

enum FilterGroup: String {
  case base = "Base",
       owner = "Owner",
       industry = "Industry",
       revenue = "Revenue",
       state = "State",
       city = "City"
  
  var color: UIColor {
    switch self {
    case .owner:
      return .brandYellowDark
    case .industry:
      return .brandGreenDark
    case .state:
      return .brandPinkDark
    default:
      return .brandYellowDark
    }
  }
}
