//
//  AccountSFDataStore.swift
//  Whaler
//
//  Created by Zachary Rhodes on 1/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

struct AccountSFDataSource {
  func fetchAll() -> AnyPublisher<[Account], RepoError> {
    return Future<[Account], RepoError> { promise in
      let accounts = fetchAccountsFromSalesforce(with: nil)
      promise(.success(accounts))
    }.eraseToAnyPublisher()
  }
  
  func fetchSubset(with filters: Set<Filter>) -> AnyPublisher<[Account], RepoError> {
    return Future<[Account], RepoError> { promise in
      let accounts = fetchAccountsFromSalesforce(with: filters)
      promise(.success(accounts))
    }.eraseToAnyPublisher()
  }
  
  func saveAll(_ new: [Account]) -> AnyPublisher<[Account], RepoError> {
    fatalError("Not implemented")
  }
  
  func fetchAccountsFromSalesforce(with filters: Set<Filter>?) -> [Account] {
    return SFHelper.queryAccounts(with: filters)
  }
}
