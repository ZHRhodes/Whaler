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
  
  func saveTrackingChanges(_ trackingChanges: [TrackingChange<Account>]) -> AnyPublisher<[Account], RepoError> {
    let input: [AccountTrackingChange] = trackingChanges.map { (trackingChange) in
      return AccountTrackingChange(account: makeNewAccount(from: trackingChange.value),
                                   newState: trackingChange.newTrackingState.rawValue)
    }
    
    return Future<[Account], RepoError> { promise in
      Graph.shared.apollo.perform(mutation: ApplyAccountTrackingChangesMutation(input: input)) { result in
        guard let data = try? result.get().data else { return promise(.failure(RepoError(reason: "Failed to save tracking changes remotely",
                                                                                         humanReadableMessage: nil)))}
        let accounts = data.trackedAccounts.map(Account.init)
        promise(.success(accounts))
      }
    }.eraseToAnyPublisher()
  }
  
  private func makeNewAccount(from account: Account) -> NewAccount {
    return NewAccount(id: account.id,
                      salesforceId: account.salesforceID,
                      name: account.name,
                      industry: account.industry,
                      description: account.accountDescription,
                      numberOfEmployees: account.numberOfEmployees,
                      annualRevenue: account.annualRevenue,
                      billingCity: account.billingCity,
                      billingState: account.billingState,
                      phone: account.phone,
                      website: account.website,
                      type: account.type,
                      state: account.state?.rawValue,
                      notes: account.notes)
  }
}
