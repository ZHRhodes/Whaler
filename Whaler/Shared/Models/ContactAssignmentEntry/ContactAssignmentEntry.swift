//
//  ContactAssignmentEntry.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/22/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct ContactAssignmentEntry {
  let id: String
  let createdAt: Date
  let contactId: String
  let assignedBy: String
  let assignedTo: String?
  
  init(contactId: String, assignedBy: String, assignedTo: String?) {
    self.id = ""
    self.createdAt = Date()
    self.contactId = contactId
    self.assignedBy = assignedBy
    self.assignedTo = assignedTo
  }
  
  init(id: String, createdAt: Date, contactId: String, assignedBy: String, assignedTo: String?) {
    self.id = id
    self.createdAt = createdAt
    self.contactId = contactId
    self.assignedBy = assignedBy
    self.assignedTo = assignedTo
  }
}

extension ContactAssignmentEntry: RepoStorable {}
