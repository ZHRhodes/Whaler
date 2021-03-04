//
//  AccountRemoteDataSource.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/12/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

struct AccountRemoteDataSource {
  func fetchAll() -> AnyPublisher<[Account], RepoError> {
    return Future<[Account], RepoError> { promise in
      let accountsHelper = AccountsHelper()
      accountsHelper.fetchAccountsFromAPI { (accounts) in
        promise(.success(accounts ?? []))
      }
    }.eraseToAnyPublisher()
  }
  
  func saveAll(_ new: [Account]) -> AnyPublisher<[Account], RepoError> {
    return Future<[Account], RepoError> { promise in
      let accountsHelper = AccountsHelper()
      accountsHelper.saveAccountsToAPI(new) { (accounts) in
        promise(.success(accounts))
      }
    }.eraseToAnyPublisher()
  }
  
//  func saveSingle(_ new: Account) -> AnyPublisher<Account, RepoError> {
//    
//  }
}
