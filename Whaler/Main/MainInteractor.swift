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
  
  var hasNoAccounts: Bool {
    accounts.allSatisfy({ $1.isEmpty })
  }
  
  init() {
    retrieveAccounts()
  }
  
  func parseAccounts(from url: URL) {
    guard let csv = CSVParser.parseCSV(fileUrl: url, encoding: .utf8) else { return }
    let (parsedAccounts, _) = CSVParser.parseAccountsAndContacts(from: csv)
    for account in parsedAccounts {
      accounts[account.state]?.append(account)
      ObjectManager.save(account)
    }
  }
  
  func moveAccount(from fromPath: IndexPath, to toPath: IndexPath) {
    let fromState = accountStates[fromPath.section]
    guard let accountBeingMoved = accounts[fromState]?.remove(at: fromPath.row) else { return }

    let toState = accountStates[toPath.section]
    accountBeingMoved.state = toState
    accounts[toState]?.insert(accountBeingMoved, at: toPath.row)
  }
  
  func retrieveAccounts() {
    let retrievedAccounts = ObjectManager.retrieveAll(ofType: Account.self)
    for account in retrievedAccounts {
      accounts[account.state]?.append(account)
    }
  }
  
  func deleteAccounts() {
    accounts = .init(uniqueKeysWithValues: self.accountStates.map { ($0, []) })
    ObjectManager.deleteAll(ofType: Account.self)
  }
}
