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
}
