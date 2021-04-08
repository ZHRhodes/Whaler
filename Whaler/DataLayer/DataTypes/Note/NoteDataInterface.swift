//
//  NoteDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class NoteDataInterface: DataInterface {
  typealias Entity = Note
  
  typealias AllDataRequestType = Void
  typealias SubsetDataRequestType = Void
  typealias SingleDataRequestType = String
  
  typealias DataSaveType = Note
  
  private let remoteDataSource: NoteRemoteDataSource
  
  init(remoteDataSource: NoteRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }
  
  func fetchAll(with dataRequest: Void?) -> AnyPublisher<[Note], RepoError> {
    fatalError("not implemented")
  }
  
  func fetchSubset(with dataRequest: Void) -> AnyPublisher<[Note], RepoError> {
    fatalError("not implemented")
  }
  
  func fetchSingle(with dataRequest: SingleDataRequestType) -> AnyPublisher<Note?, RepoError> {
    return remoteDataSource.fetchSingle(accountID: dataRequest)
  }
  
  func save(_ data: DataSaveType) -> AnyPublisher<[Note], RepoError> {
    return remoteDataSource.save(note: data).map { [$0] }.eraseToAnyPublisher()
  }
}
