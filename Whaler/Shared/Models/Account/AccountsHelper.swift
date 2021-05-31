//
//  AccountsHelper.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/25/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct AccountsHelper {
  func fetchAccountsFromAPI(completion: @escaping ([Account]?) -> Void) {
    Graph.shared.apollo.fetch(query: AccountsQuery(), cachePolicy: .fetchIgnoringCacheData) { result in
      do {
        guard let data = try result.get().data else { throw "Apollo account fetch data was nil" }
        completion(data.accounts.map(Account.init))
      } catch {
        Log.error("Failed to fetch and decode accounts from Apollo. Error: \(error)")
        completion(nil)
      }
    }
  }
  
  func saveAccountsToAPI(_ accounts: [Account], completion: @escaping ([Account]) -> Void) {
    let input = accounts.map { NewAccount(id: $0.id,
                                          salesforceId: $0.salesforceID,
                                          name: $0.name,
                                          industry: $0.industry,
                                          description: $0.accountDescription,
                                          numberOfEmployees: $0.numberOfEmployees,
                                          annualRevenue: $0.annualRevenue,
                                          billingCity: $0.billingCity,
                                          billingState: $0.billingState,
                                          phone: $0.phone,
                                          website: $0.website,
                                          type: $0.type,
                                          state: $0.state?.rawValue,
                                          notes: $0.notes,
                                          assignedTo: $0.assignedTo) }
    Graph.shared.apollo.perform(mutation: SaveAccountsMutation(senderID: clientId, input: input)) { result in
      guard let data = try? result.get().data else { return }
      let accounts = data.saveAccounts.map(Account.init)
      completion(accounts)
    }
  }
}
