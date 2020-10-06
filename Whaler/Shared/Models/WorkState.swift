//
//  WorkState.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit

enum WorkState: String, CaseIterable, Codable {
  case ready = "READY", inProgress = "IN PROGRESS", worked = "WORKED"
  
  var backgroundColor: UIColor {
    switch self {
    case .inProgress:
      return .brandPurpleLight
    case .ready:
      return .brandGreenLight
    case .worked:
      return .brandRedLight
    }
  }
  
  var foregroundColor: UIColor {
    switch self {
    case .inProgress:
      return .brandPurpleDark
    case .ready:
      return .brandGreenDark
    case .worked:
      return .brandRedDark
    }
  }
}

extension WorkState: Identifiable {
  var id: String { rawValue }
}
