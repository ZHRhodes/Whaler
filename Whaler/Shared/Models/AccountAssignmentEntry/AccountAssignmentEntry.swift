//
//  AccountAssignmentEntry.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/3/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct AccountAssignmentEntry {
  let id: String
  let createdAt: Date
  let accountId: String
  let assignedBy: String
  let assignedTo: String?
  
  init(accountId: String, assignedBy: String, assignedTo: String?) {
    self.id = ""
    self.createdAt = Date()
    self.accountId = accountId
    self.assignedBy = assignedBy
    self.assignedTo = assignedTo
  }
  
  init(id: String, createdAt: Date, accountId: String, assignedBy: String, assignedTo: String?) {
    self.id = id
    self.createdAt = createdAt
    self.accountId = accountId
    self.assignedBy = assignedBy
    self.assignedTo = assignedTo
  }
}

extension AccountAssignmentEntry: RepoStorable {}
