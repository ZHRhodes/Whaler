//
//  Task.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct Task: Codable, RepoStorable {
  var id: String
  var createdAt: Date
  var associatedTo: String?
  var description: String
  var done: Bool
  var type: String?
  var dueDate: Date?
  var assignedTo: String
  
  init(id: String = UUID().uuidString.lowercased(),
       createdAt: Date = Date(),
       associatedTo: String?,
       description: String,
       done: Bool,
       type: String?,
       dueDate: Date?,
       assignedTo: String) {
    self.id = id
    self.createdAt = createdAt
    self.associatedTo = associatedTo
    self.description = description
    self.done = done
    self.type = type
    self.dueDate = dueDate
    self.assignedTo = assignedTo
  }
}
