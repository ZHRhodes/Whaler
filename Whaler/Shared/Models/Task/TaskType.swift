//
//  TaskType.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/29/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

enum TaskType: String, Codable, CaseIterable {
  case email, admin, call
}

extension TaskType: SimpleItem {
  var name: String {
    switch self {
    case .email:
      return "Email"
    case .admin:
      return "Admin"
    case .call:
      return "Call"
    }
  }
  
  var icon: UIImage? {
    nil
  }
}
