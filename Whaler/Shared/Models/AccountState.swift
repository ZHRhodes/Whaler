//
//  AccountState.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit

enum AccountState: String, CaseIterable {
  case inProgress = "In Progress", ready = "Ready", worked = "Worked"
  
  var color: UIColor {
    switch self {
    case .inProgress:
      return .inProgress
    case .ready:
      return .ready
    case .worked:
      return .worked
    }
  }
}
