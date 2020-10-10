//
//  Organization.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/10/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct Organization: Codable {
  let id: Int
  var name: String = ""
  var users: [User] = []
}

extension Organization: Equatable {}
 
