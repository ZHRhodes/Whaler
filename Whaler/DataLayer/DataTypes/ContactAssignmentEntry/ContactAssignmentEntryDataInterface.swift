//
//  ContactAssignmentEntryDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/22/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class ContactAssignmentEntryDataInterface: DataInterface {
  typealias Entity = ContactAssignmentEntry
  
  typealias AllDataRequestType = Void
  typealias SubsetDataRequestType = Void
  typealias SingleDataRequestType = Void
  
  typealias DataSaveType = ContactAssignmentEntry
  
  private let remoteDataSource: ContactAssignmentEntryRemoteDataSource
  
  init(remoteDataSource: ContactAssignmentEntryRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }
  
  func fetchAll(with dataRequest: Void?) -> AnyPublisher<[ContactAssignmentEntry], RepoError> {
    fatalError("not implemented")
  }
  
  func fetchSubset(with dataRequest: Void) -> AnyPublisher<[ContactAssignmentEntry], RepoError> {
    fatalError("not implemented")
  }
  
  func fetchSingle(with dataRequest: Void) -> AnyPublisher<ContactAssignmentEntry?, RepoError> {
    fatalError("not implemented")
  }
  
  func save(_ data: DataSaveType) -> AnyPublisher<[ContactAssignmentEntry], RepoError> {
    return remoteDataSource.save(data).map { [$0] }.eraseToAnyPublisher()
  }
}
