//
//  AccountDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 1/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class AccountDataInterface: DataInterface {
  private let remoteDataSource: AccountDataSource
  private let sfDataSource: AccountDataSource
  private var cancellable: AnyCancellable?
  
  init(remoteDataSource: AccountDataSource,
       sfDataSource: AccountDataSource) {
    self.remoteDataSource = remoteDataSource
    self.sfDataSource = sfDataSource
  }
  
  func fetchAll() -> AnyPublisher<[RepoStorable], Error> {
    return Future<[RepoStorable], Error> { [weak self] promise in
      guard let strongSelf = self else { return }
      strongSelf.cancellable = strongSelf.remoteDataSource
        .fetchAll()
        .zip(strongSelf.sfDataSource.fetchAll())
        .sink { (status) in
        print(status)
      } receiveValue: { (remoteAccounts, sfAccounts) in
        sfAccounts.forEach { account in
          if let matchingLocalAccount = remoteAccounts.first(where: { $0.salesforceID == account.salesforceID }) {
            account.mergeLocalProperties(with: matchingLocalAccount)
          }
        }
        promise(.success(sfAccounts))
      }
    }.eraseToAnyPublisher()
  }
}
