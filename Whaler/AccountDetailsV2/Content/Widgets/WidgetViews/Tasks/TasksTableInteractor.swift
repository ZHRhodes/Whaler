//
//  TasksTableInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class TasksTableInteractor {
  private var associatedTo: String
  private var bag = Set<AnyCancellable>()
  private(set) var tasks: [Task] = []
  let dataChanged = PassthroughSubject<Void, Never>()
  
  init(associatedObjectId: String) {
    self.associatedTo = associatedObjectId
    subscribeToTasks()
  }
  
  private func subscribeToTasks() {
    repoStore
      .taskRepository
      .fetchSubset(with: associatedTo)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] (tasks) in
              self?.tasks = tasks
              self?.dataChanged.send()
            })
      .store(in: &bag)
  }
  
  func setDate(newDate: Date, forTask task: Task) {
    var task = task
    task.dueDate = newDate
    save(task)
  }
  
  func setDescription(new: String, forTask task: Task) {
    var task = task
    task.description = new
    save(task)
  }
  
  func assign(task: Task, to assignee: String?) {
    guard let currentUser = Lifecycle.currentUser else { return }
    var task = task
    let taskAssignmentEntry = TaskAssignmentEntry(taskId: task.id, assignedBy: currentUser.id, assignedTo: assignee)
    task.assignedTo = assignee ?? ""
    repoStore
      .taskAssignmentEntryRepository
      .save(taskAssignmentEntry)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] (_) in
              self?.upsert(task: task)
              self?.dataChanged.send()
            })
      .store(in: &bag)
  }
  
  func save(_ task: Task) {
    repoStore
      .taskRepository
      .save(task)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] (tasks) in
              guard let savedTask = tasks.first else { return }
              self?.upsert(task: savedTask)
              self?.dataChanged.send()
            })
      .store(in: &bag)
  }
  
  private func upsert(task: Task) {
    if let existingIndex = tasks.firstIndex(where: { $0.id == task.id }) {
      tasks[existingIndex] = task
    } else {
      tasks.append(task)
    }
  }
  
  @objc
  func addTask() {
    let newTask = Task(associatedTo: associatedTo,
                       description: "",
                       done: false,
                       type: nil,
                       dueDate: nil,
                       assignedTo: "")
    let newTaskCollection = CollectionOfOne(newTask)
    tasks = newTaskCollection + tasks
    dataChanged.send()
  }
}
