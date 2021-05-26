//
//  TasksTableInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

class TasksTableInteractor {
  var tasks = [Task]([Task(id: "123", createdAt: Date(), associatedTo: "123", description: "Call Adam", done: false, type: "Email", dueDate: Date(), assignedTo: "me"),Task(id: "Say Hi To Chip", createdAt: Date(), associatedTo: "123", description: "This thing", done: false, type: "Admin", dueDate: Date(), assignedTo: "me"),Task(id: "123", createdAt: Date(), associatedTo: "123", description: "Wash Hands", done: false, type: "Email", dueDate: Date(), assignedTo: "me"),Task(id: "123", createdAt: Date(), associatedTo: "123", description: "Description", done: false, type: "Email", dueDate: Date(), assignedTo: "me"),Task(id: "123", createdAt: Date(), associatedTo: "123", description: "This is the description", done: false, type: "Call", dueDate: Date(), assignedTo: "me"),Task(id: "123", createdAt: Date(), associatedTo: "123", description: "Huuh HUH", done: false, type: "Admin", dueDate: Date(), assignedTo: "me"),Task(id: "123", createdAt: Date(), associatedTo: "123", description: "Brush Teeth", done: false, type: "Admin", dueDate: Date(), assignedTo: "me"),Task(id: "123", createdAt: Date(), associatedTo: "123", description: "Make bed", done: false, type: "Call", dueDate: Date(), assignedTo: "me")])
  
  func setDate(newDate: Date, forTask task: Task) {
    
  }
}
