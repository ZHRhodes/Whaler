//
//  TaskOption.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/29/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

enum TaskOption: String, CaseIterable {
  case delete
}

extension TaskOption: SimpleItem {
  var name: String {
    switch self {
    case .delete:
      return "Delete"
    }
  }
  
  var icon: UIImage? {
    return nil
  }
}
