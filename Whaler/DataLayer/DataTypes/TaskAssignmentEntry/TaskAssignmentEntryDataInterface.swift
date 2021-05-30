//
//  TaskAssignmentEntryDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/29/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class TaskAssignmentEntryDataInterface: DataInterface {
  typealias Entity = TaskAssignmentEntry
  
  typealias AllDataRequestType = Void
  typealias SubsetDataRequestType = Void
  typealias SingleDataRequestType = Void
  
  typealias DataSaveType = TaskAssignmentEntry
  
  private let remoteDataSource: TaskAssignmentEntryRemoteDataSource
  
  init(remoteDataSource: TaskAssignmentEntryRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }
  
  func fetchAll(with dataRequest: Void?) -> AnyPublisher<[Entity], RepoError> {
    fatalError("not implemented")
  }
  
  func fetchSubset(with dataRequest: Void) -> AnyPublisher<[Entity], RepoError> {
    fatalError("not implemented")
  }
  
  func fetchSingle(with dataRequest: Void) -> AnyPublisher<Entity?, RepoError> {
    fatalError("not implemented")
  }
  
  func save(_ data: DataSaveType) -> AnyPublisher<[Entity], RepoError> {
    return remoteDataSource.save(data).map { [$0] }.eraseToAnyPublisher()
  }
}
