//
//  OTOp.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

fileprivate let noop = OTOp(n: 0, s: "")

struct OTOp: Codable {
  var n: Int
  var s: String
  
  init(n: Int = 0, s: String = "") {
    self.n = n
    self.s = s
  }
  
  var isNoop: Bool {
    return n == 0 && s.isEmpty
  }
}
