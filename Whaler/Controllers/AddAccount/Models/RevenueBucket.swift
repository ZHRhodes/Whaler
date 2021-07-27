//
//  RevenueBucket.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/30/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct RevenueBucket {
  let lowerBound: Int
  let upperBound: Int?
  var units = "M"
}

extension RevenueBucket: FieldValue {
  var string: String {
    if let upperBound = upperBound {
      return "\(lowerBound) - \(upperBound) \(units)"
    } else {
      return "\(lowerBound) \(units)+"
    }
  }
}
