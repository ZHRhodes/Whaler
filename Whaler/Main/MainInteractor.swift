//
//  MainInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import AuthenticationServices

class MainInteractor {
  lazy var accountGrouper = Grouper<WorkState, Account>(groups: self.accountStates)
  lazy var accountStates = WorkState.allCases
  
  var hasNoAccounts: Bool {
    accountGrouper.hasNoValues
  }
  
  var hasSalesforceTokens: Bool {
    SFSession.loadSFTokens()
    return SFSession.hasTokens()
  }
  
  init() {
//    retrieveAccounts()
  }
  
  func parseAccountsAndContacts(from url: URL) {
    guard let csv = CSVParser.parseCSV(fileUrl: url, encoding: .utf8) else { return }
    let (parsedAccounts, parsedContacts) = CSVParser.parseAccountsAndContacts(from: csv)
    
    parsedAccounts.forEach { account in
      accountGrouper.append(account, to: account.state)
      ObjectManager.save(account)
    }
    
    parsedContacts.forEach { contact in
      ObjectManager.save(contact)
    }
  }
  
  func moveAccount(from fromPath: IndexPath, to toPath: IndexPath) {
    let fromState = accountStates[fromPath.section]
    guard let accountBeingMoved = accountGrouper.remove(from: fromState, at: fromPath.row) else { return }

    let toState = accountStates[toPath.section]
    accountBeingMoved.state = toState
    accountGrouper.insert(accountBeingMoved, to: toState, at: toPath.row)
    
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
    accountGrouper.resetValues()
    newAccounts.forEach { account in
      accountGrouper.append(account, to: account.state)
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
      account.contactGrouper.append(contact, to: contact.state)
    }
  }
  
  private func retrieveAndAssignContacts() {
    let retrievedContacts = ObjectManager.retrieveAll(ofType: Contact.self)
    let accountsMap = createAccountsMap()
    retrievedContacts.forEach { contact in
      accountsMap[contact.accountID]?.contactGrouper.append(contact, to: contact.state)
    }
  }
  
  private func createAccountsMap() -> [String: Account] {
    var map = [String: Account]()
    accountGrouper.values.forEach { account in
      map[account.id] = account
    }
    
    return map
  }
  
  func deleteAccounts() {
    accountGrouper.resetValues()
    ObjectManager.deleteAll(ofType: Account.self)
  }
  
  func fetchAccountsFromSalesforce() {
    let soql = "SELECT id, name, type, industry, annualRevenue, billingCity, billingState, phone, website, numberOfEmployees, ownerId, description from Account WHERE (NOT type like 'Customer%')"
    var sfAccounts = [SF.Account]()
    do {
      sfAccounts = try SF.query(soql)
    } catch let error {
      print(error)
    }

    let accounts = sfAccounts.map(Account.init)
    setAccounts(accounts)
    
    print(accountGrouper)
  }
  
  func makeSFAuthenticationSession(completion: @escaping VoidClosure) -> ASWebAuthenticationSession? {
    let session = SFHelper.makeAuthenticationSession { [weak self] in
      self?.fetchAccountsFromSalesforce()
      completion()
    }
    
    return session
  }
  
  func refreshSalesforceSession(completion: @escaping BoolClosure) {
    do {
      try SF.refreshAccessToken()
      completion(true)
    } catch let error {
      print(error)
      //log this
      completion(false)
    }
  }
}
