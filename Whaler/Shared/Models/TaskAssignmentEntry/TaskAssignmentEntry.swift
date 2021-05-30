//
//  TaskAssignmentEntry.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/29/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct TaskAssignmentEntry {
  let id: String
  let createdAt: Date
  let taskId: String
  let assignedBy: String
  let assignedTo: String?
  
  init(taskId: String, assignedBy: String, assignedTo: String?) {
    self.id = ""
    self.createdAt = Date()
    self.taskId = taskId
    self.assignedBy = assignedBy
    self.assignedTo = assignedTo
  }
  
  init(id: String, createdAt: Date, taskId: String, assignedBy: String, assignedTo: String?) {
    self.id = id
    self.createdAt = createdAt
    self.taskId = taskId
    self.assignedBy = assignedBy
    self.assignedTo = assignedTo
  }
}

extension TaskAssignmentEntry: RepoStorable {}
