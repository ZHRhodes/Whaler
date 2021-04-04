//
//  AccountAssignmentEntryDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/3/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class AccountAssignmentEntryDataInterface: DataInterface {
  typealias Entity = AccountAssignmentEntry
  
  typealias AllDataRequestType = Void
  typealias SubsetDataRequestType = Void
  typealias SingleDataRequestType = Void
  
  typealias DataSaveType = AccountAssignmentEntry
  
  private let remoteDataSource: AccountAssignmentEntryRemoteDataSource
  
  init(remoteDataSource: AccountAssignmentEntryRemoteDataSource) {
    self.remoteDataSource = remoteDataSource
  }
  
  func fetchAll(with dataRequest: Void?) -> AnyPublisher<[AccountAssignmentEntry], RepoError> {
    fatalError("not implemented")
  }
  
  func fetchSubset(with dataRequest: Void) -> AnyPublisher<[AccountAssignmentEntry], RepoError> {
    fatalError("not implemented")
  }
  
  func fetchSingle(with dataRequest: Void) -> AnyPublisher<AccountAssignmentEntry?, RepoError> {
    fatalError("not implemented")
  }
  
  func save(_ data: DataSaveType) -> AnyPublisher<[AccountAssignmentEntry], RepoError> {
    return remoteDataSource.save(data).map { [$0] }.eraseToAnyPublisher()
  }
}
