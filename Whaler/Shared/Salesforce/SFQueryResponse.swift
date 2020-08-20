//
//  SFQueryResponse.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

extension SF {
  struct QueryResponse<T: Decodable>: Decodable {
    let totalSize: Int?
    let done: Bool?
    let records: [T]?
  }
}
