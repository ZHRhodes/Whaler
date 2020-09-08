//
//  UserRemote.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/7/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct UserRemote: Codable {
  let id: Int
  let email: String
  let firstName: String
  let lastName: String
  let isAdmin: Bool
  let organizationId: UInt
//  let workspaces: [WorkspaceRemote]?
}
