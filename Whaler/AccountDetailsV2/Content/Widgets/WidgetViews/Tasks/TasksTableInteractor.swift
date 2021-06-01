//
//  TasksTableInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine
import Starscream

class TasksTableInteractor {
  private var associatedTo: String
  private var tasksCancellable: AnyCancellable?
  private var bag = Set<AnyCancellable>()
  private(set) var tasks: [Task] = []
  let dataChanged = PassthroughSubject<Void, Never>()
  
  init(associatedObjectId: String) {
    self.associatedTo = associatedObjectId
    subscribeToTasks()
  }
  
  ///For now, it's necessary to pull new tasks.
  ///Data push mechanism is not set up for subset use-case.
  func refetchTasks() {
    subscribeToTasks()
  }
  
  private func subscribeToTasks() {
    tasksCancellable = repoStore
      .taskRepository
      .fetchSubset(with: associatedTo)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] (tasks) in
              self?.setTasks(new: tasks)
              self?.dataChanged.send()
            })
  }
  
  func setDone(new: Bool, forTask task: Task) {
    var task = task
    task.done = new
    save(task)
  }
  
  func setDate(new: Date, forTask task: Task) {
    var task = task
    task.dueDate = new
    save(task)
  }
  
  func setDescription(new: String, forTask task: Task) {
    var task = task
    task.description = new
    save(task)
  }
  
  func setType(new: TaskType, forTask task: Task) {
    var task = task
    task.type = new
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
              self?.updateData(with: task)
              self?.dataChanged.send()
            })
      .store(in: &bag)
  }
  
  func delete(task: Task) {
    var task = task
    task.deletedAt = Date()
    save(task)
  }
  
  private func setTasks(new tasks: [Task]) {
    self.tasks = orderChronologicalMovingDoneToBottom(tasks: tasks)
  }
  
  private func orderChronologicalMovingDoneToBottom(tasks: [Task]) -> [Task] {
    var notDone = [Task]()
    var done = [Task]()
  
    for task in tasks {
      if task.done {
        done.append(task)
      } else {
        notDone.append(task)
      }
    }
    
    notDone.sort(by: { (a, b) -> Bool in
      var aSortDate = a.dueDate
      var bSortDate = b.dueDate
      
      if aSortDate == bSortDate {
        aSortDate = b.createdAt
        bSortDate = a.createdAt
      }
      
      if aSortDate == nil {
        return true
      }
      
      if bSortDate == nil {
        return false
      }
      
      return aSortDate! < bSortDate!
    })
    
    return notDone + done
  }
  
  private func save(_ task: Task) {
    repoStore
      .taskRepository
      .save(task)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] (tasks) in
              guard let strongSelf = self,
                    let savedTask = tasks.first else { return }
              strongSelf.updateData(with: savedTask)
              strongSelf.setTasks(new: strongSelf.tasks)
              strongSelf.dataChanged.send()
            })
      .store(in: &bag)
  }
  
  private func updateData(with task: Task) {
    if let existingIndex = tasks.firstIndex(where: { $0.id == task.id }) {
      if task.deletedAt != nil {
        tasks.remove(at: existingIndex)
      } else {
        tasks[existingIndex] = task
      }
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

extension TasksTableInteractor: LiteWebSocketDelegate {
  func didReceiveMessage(_ message: SocketMsg, socket: WebSocketClient) {
    switch message {
    case .resourceUpdated(let resourceIdOfUpdated):
      //refetch
      break
    default: break
    }
  }
  
  func connectionEstablished(socket: WebSocketClient) {}
	func socketDisconnected(socket: WebSocketClient, error: Error?) {}
}
