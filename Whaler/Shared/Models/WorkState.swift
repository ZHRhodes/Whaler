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

extension WorkState: Identifiable {
  var id: String { rawValue }
}
