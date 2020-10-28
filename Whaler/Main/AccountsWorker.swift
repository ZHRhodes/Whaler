//
//  AccountsWorker.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/25/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct AccountsWorker {
  func fetchAccountsFromSalesforce() -> [Account] {
    return SFHelper.queryAccounts()
  }
  
  func fetchAccountsFromAPI(completion: @escaping ([Account]?) -> Void) {
    Graph.shared.apollo.fetch(query: AccountsQuery()) { result in
      guard let data = try? result.get().data else { return }
      print(data.accounts)
      completion([])
    }
//    return []
  }
}
