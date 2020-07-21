//
//  MainInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

class MainInteractor {
  lazy var accounts: [WorkState: [Account]] = .init(uniqueKeysWithValues: self.accountStates.map { ($0, []) })
  lazy var accountStates = WorkState.allCases
  
  func parseAccounts(from url: URL) {
    guard let accountsDicts = CSVParser.parseCSV(fileUrl: url, encoding: .utf8) else { return }
    for dict in accountsDicts {
      let account = Account(dictionary: dict)
      accounts[account.state]?.append(account)
    }
  }
  
  func moveAccount(from fromPath: IndexPath, to toPath: IndexPath) {
    let fromState = accountStates[fromPath.section]
    guard let accountBeingMoved = accounts[fromState]?.remove(at: fromPath.row) else { return }

    let toState = accountStates[toPath.section]
    accountBeingMoved.state = toState
    accounts[toState]?.insert(accountBeingMoved, at: toPath.row)
  }
}
