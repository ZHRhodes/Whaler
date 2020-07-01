//
//  MainInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

class MainInteractor {
  var accounts: [Account] = []
  let accountStates = AccountState.allCases
  
  func parseAccounts(from url: URL) {
    guard let accountsDicts = CSVParser.parseCSV(fileUrl: url, encoding: .utf8) else { return }
    accounts = accountsDicts.map({ Account(dictionary: $0) })
  }
}
