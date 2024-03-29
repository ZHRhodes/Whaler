//
//  DocumentChange.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/26/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct DocumentChange: SocketData {
  var resourceId: String
  var rev: Int
  var n: [Int]
  var s: [String]
  
  init(resourceId: String, rev: Int, ops: [OTOp]) {
    self.resourceId = resourceId
    self.rev = rev
    self.n = [Int]()
    self.s = [String]()
    for op in ops {
      n.append(op.n)
      s.append(op.s)
    }
  }
}

struct DocumentChangeReturn: SocketData {
  var resourceId: String
  var n: [Int]
  var s: [String]
}
