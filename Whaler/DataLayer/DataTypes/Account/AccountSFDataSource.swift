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
      let accountsHelper = AccountsHelper()
      let accounts = accountsHelper.fetchAccountsFromSalesforce()
      promise(.success(accounts))
    }.eraseToAnyPublisher()
  }
  
  func saveAll(_ new: [Account]) -> AnyPublisher<[Account], RepoError> {
    fatalError("Not implemented")
  }
}
