//
//  TaskDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/25/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class TaskDataInterface: DataInterface {
  typealias Entity = Task
  
  typealias AllDataRequestType = Void
  typealias SubsetDataRequestType = String
  typealias SingleDataRequestType = Void
  
  typealias DataSaveType = Task
  
  private let remoteDataSource: TaskRemoteDataSource
  
  init(remoteDataSource: TaskRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }
  
  func fetchAll(with dataRequest: AllDataRequestType?) -> AnyPublisher<[Entity], RepoError> {
    fatalError("not implemented")
  }
  
  func fetchSubset(with dataRequest: SubsetDataRequestType) -> AnyPublisher<[Entity], RepoError> {
    return remoteDataSource.fetchSubset(associatedTo: dataRequest)
  }
  
  func fetchSingle(with dataRequest: SingleDataRequestType) -> AnyPublisher<Entity?, RepoError> {
    fatalError("not implemented")
  }
  
  func save(_ data: DataSaveType) -> AnyPublisher<[Entity], RepoError> {
    return remoteDataSource.save(task: data).map({ [$0] }).eraseToAnyPublisher()
  }
}
