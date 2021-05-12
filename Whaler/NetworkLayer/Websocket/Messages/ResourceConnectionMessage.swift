//
//  ResourceConnectionMessage.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/28/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct ResourceConnection: Codable {
  let resourceId: String
}

struct ResourceConnectionConf: Codable {
  let resourceId: String
  let initialState: String
  let revision: Int
}
