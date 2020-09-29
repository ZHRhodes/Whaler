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
      return .inProgressBackground
    case .ready:
      return .readyBackground
    case .worked:
      return .workedBackground
    }
  }
  
  var foregroundColor: UIColor {
    switch self {
    case .inProgress:
      return .inProgressForeground
    case .ready:
      return .readyForeground
    case .worked:
      return .workedForeground
    }
  }
}

extension WorkState: Identifiable {
  var id: String { rawValue }
}
