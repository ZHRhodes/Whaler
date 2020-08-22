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
//    retrieveAccounts()
  }
  
  func parseAccountsAndContacts(from url: URL) {
    guard let csv = CSVParser.parseCSV(fileUrl: url, encoding: .utf8) else { return }
    let (parsedAccounts, parsedContacts) = CSVParser.parseAccountsAndContacts(from: csv)
    
    parsedAccounts.forEach { account in
      accounts[account.state]?.append(account)
      ObjectManager.save(account)
    }
    
    parsedContacts.forEach { contact in
      ObjectManager.save(contact)
    }
  }
  
  func moveAccount(from fromPath: IndexPath, to toPath: IndexPath) {
    let fromState = accountStates[fromPath.section]
    guard let accountBeingMoved = accounts[fromState]?.remove(at: fromPath.row) else { return }

    let toState = accountStates[toPath.section]
    accountBeingMoved.state = toState
    accounts[toState]?.insert(accountBeingMoved, at: toPath.row)
    
    ObjectManager.save(accountBeingMoved) //Move, or make this async, or both
  }
  
  func retrieveAccounts() {
    let retrievedAccounts = ObjectManager.retrieveAll(ofType: Account.self)
    setAccounts(retrievedAccounts)
    
    //store contact count to Account so that this isn't
    //required in order to show correct number of contacts on the accounts page
    retrieveAndAssignContacts()
  }
  
  func setAccounts(_ newAccounts: [Account]) {
    accounts = .init(uniqueKeysWithValues: self.accountStates.map { ($0, []) })
    newAccounts.forEach { account in
      accounts[account.state]?.append(account)
    }
  }
  
  func retrieveAndAssignContacts(for account: Account) {
//    let predicate = NSPredicate(format: "accountID == %@", account.id)
//    let retrievedContacts = ObjectManager.retrieveAll(ofType: Contact.self, with: predicate)
//    account.contacts = .init(uniqueKeysWithValues: WorkState.allCases.map { ($0, []) })
//    retrievedContacts.forEach { contact in
//      account.contacts[contact.state]?.append(contact)
//    }
    
    account.resetContacts()
    let retrievedContacts = SFHelper.queryContacts(accountId: account.id, accountName: account.name)
    retrievedContacts.forEach { contact in
      account.contacts[contact.state]?.append(contact)
    }
  }
  
  private func retrieveAndAssignContacts() {
    let retrievedContacts = ObjectManager.retrieveAll(ofType: Contact.self)
    let accountsMap = createAccountsMap()
    retrievedContacts.forEach { contact in
      accountsMap[contact.accountID]?.contacts[contact.state]?.append(contact)
    }
  }
  
  private func createAccountsMap() -> [String: Account] {
    var map = [String: Account]()
    accounts.values.flatMap { $0 }.forEach { account in
      map[account.id] = account
    }
    
    return map
  }
  
  func deleteAccounts() {
    accounts = .init(uniqueKeysWithValues: self.accountStates.map { ($0, []) })
    ObjectManager.deleteAll(ofType: Account.self)
  }
  
  func fetchAccountsFromSalesforce() {
    let soql = "SELECT id, name, type, industry, annualRevenue, billingCity, billingState, phone, website, numberOfEmployees, ownerId, description from Account WHERE (NOT type like 'Customer%')"
    let sfAccounts: [SF.Account] = try! SF.query(soql)
    print(accounts)
    print()
    
    let accounts = sfAccounts.map(Account.init)
    setAccounts(accounts)
    print(accounts)
  }
}
