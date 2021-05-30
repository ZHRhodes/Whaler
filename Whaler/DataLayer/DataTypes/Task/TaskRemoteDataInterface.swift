//
//  TaskRemoteDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/25/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

struct TaskRemoteDataSource {
  func fetchSubset(associatedTo: String) -> AnyPublisher<[Task], RepoError> {
    return Future<[Task], RepoError> { promise in
      let query = TasksQuery(associatedTo: associatedTo)
      Graph.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in
        guard let resultTasks = try? result.get().data?.tasks else {
          promise(.failure(RepoError(reason: "Failed to query tasks.",
                                                                                           
                                     humanReadableMessage: nil)))
          return
        }
        let formatter = DateFormatter.default
        let tasks = resultTasks.map { task -> Task in
          let createdDate = formatter.date(from: task.createdAt)
          
          var deletedDate: Date?
          if let deletedDateString = task.deletedAt {
            deletedDate = formatter.date(from: deletedDateString)
          }

          var dueDate: Date?
          if task.dueDate != nil {
            dueDate = formatter.date(from: task.dueDate!)
          }
          
          var type: TaskType?
          if let typeString = task.type {
            type = TaskType(rawValue: typeString)
          }

          return Task(id: task.id,
                      createdAt: createdDate ?? Date(),
                      deletedAt: deletedDate,
                      associatedTo: task.associatedTo,
                      description: task.description,
                      done: task.done,
                      type: type,
                      dueDate: dueDate,
                      assignedTo: task.assignedTo ?? "")
        }
        promise(.success(tasks))
      }
    }.eraseToAnyPublisher()
  }
  
  func save(task: Task) -> AnyPublisher<Task, RepoError> {
    return Future<Task, RepoError> { promise in
      let formatter = DateFormatter.default
      var dueDate: String?
      if task.dueDate != nil {
        dueDate = formatter.string(from: task.dueDate!)
      }
      let createdAtString = formatter.string(from: task.createdAt)
      let deletedAtString = task.deletedAt.map { formatter.string(from: $0) }

      let mutation = SaveTaskMutation(id: task.id,
                                      createdAt: createdAtString,
                                      deletedAt: deletedAtString,
                                      associatedTo: task.associatedTo,
                                      description: task.description,
                                      done: task.done,
                                      type: task.type?.rawValue,
                                      dueDate: dueDate,
                                      assignedTo: task.assignedTo)
      Graph.shared.apollo.perform(mutation: mutation) { result in
        guard let task = try? result.get().data?.saveTask else {
          promise(.failure(RepoError(reason: "Failed to mutate task.",
                                                                                           
                                     humanReadableMessage: nil)))
          return
        }
        
        let formatter = DateFormatter.default
        
        var deletedDate: Date?
        if let deletedAtString = task.deletedAt {
          deletedDate = formatter.date(from: deletedAtString)
        }
        
        let createdDate = formatter.date(from: task.createdAt)

        var dueDate: Date?
        if task.dueDate != nil {
          dueDate = formatter.date(from: task.dueDate!)
        }
        
        var type: TaskType?
        if let typeString = task.type {
          type = TaskType(rawValue: typeString)
        }
        
        promise(.success(
          Task(id: task.id,
               createdAt: createdDate ?? Date(),
               deletedAt: deletedDate,
               associatedTo: task.associatedTo,
               description: task.description,
               done: task.done,
               type: type,
               dueDate: dueDate,
               assignedTo: task.assignedTo ?? ""))
        )
      }
    }.eraseToAnyPublisher()
  }
}
