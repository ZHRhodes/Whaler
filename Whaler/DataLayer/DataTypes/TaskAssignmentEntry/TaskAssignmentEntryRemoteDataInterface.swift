//
//  TaskAssignmentEntryRemoteDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/29/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

struct TaskAssignmentEntryRemoteDataSource {
  func save(_ entry: TaskAssignmentEntry) -> AnyPublisher<TaskAssignmentEntry, RepoError> {
    return Future<TaskAssignmentEntry, RepoError> { promise in
      let mutation = CreateTaskAssignmentEntryMutation(taskId: entry.taskId,
                                                       assignedBy: entry.assignedBy,
                                                       assignedTo: entry.assignedTo)
      Graph.shared.apollo.perform(mutation: mutation) { result in
        guard let savedEntry = try? result.get().data?.taskAssignmentEntry else {
          promise(.failure(RepoError(reason: "Failed to create task assignment entry remotely", humanReadableMessage: nil)))
          return
        }
        let taskAssignmentEntry = TaskAssignmentEntry(id: savedEntry.id,
                                                      createdAt: DateFormatter.default.date(from: savedEntry.createdAt) ?? Date(),
                                                      taskId: savedEntry.taskId,
                                                      assignedBy: savedEntry.assignedBy,
                                                      assignedTo: savedEntry.assignedTo)
        promise(.success(taskAssignmentEntry))
      }
    }.eraseToAnyPublisher()
  }
}
