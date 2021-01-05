//
//  AccountDataStore.swift
//  Whaler
//
//  Created by Zachary Rhodes on 1/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

protocol AccountDataSource {
  func fetchAll() -> AnyPublisher<[Account], Error>
}

struct AccountRemoteDataSource: AccountDataSource {
  func fetchAll() -> AnyPublisher<[Account], Error> {
    return Future<[Account], Error> { promise in
      let accountsHelper = AccountsHelper()
      accountsHelper.fetchAccountsFromAPI { (accounts) in
        promise(.success(accounts ?? []))
      }
    }.eraseToAnyPublisher()
  }
}

struct AccountSFDataSource: AccountDataSource {
  func fetchAll() -> AnyPublisher<[Account], Error> {
    return Future<[Account], Error> { promise in
      let accountsHelper = AccountsHelper()
      let accounts = accountsHelper.fetchAccountsFromSalesforce()
      promise(.success(accounts))
    }.eraseToAnyPublisher()
  }
}
