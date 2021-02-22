//
//  WorkState.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit

enum WorkState: String, CaseIterable, Codable {
  case ready = "Ready", inProgress = "In Progress", worked = "Worked", opportunity = "Opportunity"
  
  static var contactsCases: [WorkState] {
    return [.ready, .inProgress, .worked]
  }
  
  var lightColor: UIColor {
    switch self {
    case .ready:
      return .brandGreenLight
    case .inProgress:
      return .brandPurpleLight
    case .worked:
      return .brandRedLight
    case .opportunity:
      return .brandYellowLight
    }
  }
  
  var color: UIColor {
    switch self {
    case .ready:
      return .brandGreen
    case .inProgress:
      return .brandPurple
    case .worked:
      return .brandRed
    case .opportunity:
      return .brandYellow
    }
  }
  
  var darkColor: UIColor {
    switch self {
    case .ready:
      return .brandGreenDark
    case .inProgress:
      return .brandPurpleDark
    case .worked:
      return .brandRedDark
    case .opportunity:
      return .brandYellowDark
    }
  }
  
  init?(from string: String?) {
    guard let string = string,
          let state = WorkState(rawValue: string) else { return nil}
    self = state
  }
}

extension WorkState: Identifiable {
  var id: String { rawValue }
}
