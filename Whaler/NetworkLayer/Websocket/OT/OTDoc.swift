//
//  OTDoc.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

class OTDoc: Codable {
//  enum CodingKeys: String, CodingKey {
//    case lines, size
//  }
  
  var lines = [[Int32]]()
  var size: Int = 0
  
//  required init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    lines = try container.decode([[Int32]].self, forKey: .lines)
//    size = try container.decode(Int.self, forKey: .size)
//  }
  
  func apply(ops: [OTOp]) throws {
    throw OTError.failedToApplyOpToDoc
  }
}
