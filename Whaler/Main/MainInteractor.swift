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
  
  func hasAccounts() -> Bool {
    return !accountGrouper.hasNoValues
  }
  
  var hasSalesforceTokens: Bool {
    SFSession.loadSFTokens()
    return SFSession.hasTokens()
  }
  
  init() {
    retrieveAccounts()
  }
  
  func parseAccountsAndContacts(from url: URL) {
    guard let csv = CSVParser.parseCSV(fileUrl: url, encoding: .utf8) else { return }
    let (parsedAccounts, parsedContacts) = CSVParser.parseAccountsAndContacts(from: csv)
    
    parsedAccounts.forEach { account in
      accountGrouper.append(account, to: account.state ?? .ready)
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
    guard let userId = Lifecycle.currentUser?.id else { return }
    let predicate = NSPredicate(format: "ownerUserId == %d", userId)
    let retrievedAccounts = ObjectManager.retrieveAll(ofType: Account.self, with: predicate)
    print(retrievedAccounts)
    setAccounts(retrievedAccounts)
    
    //store contact count to Account so that this isn't
    //required in order to show correct number of contacts on the accounts page
    retrieveAndAssignContacts()
  }
  
  func setAccounts(_ newAccounts: [Account]) {
    accountGrouper.resetValues()
    newAccounts.forEach { account in
      accountGrouper.append(account, to: account.state ?? .ready)
    }
  }
  
  func retrieveAndAssignContacts(for account: Account) {
    account.resetContacts()
    let retrievedContacts = SFHelper.queryContacts(accountId: account.id, accountName: account.name)
    let localContacts = ObjectManager.retrieveAll(ofType: Contact.self)
    reconcileContactsFromSalesforce(localContacts: localContacts, salesforceContacts: retrievedContacts)
    retrievedContacts.forEach { contact in
      account.contactGrouper.append(contact, to: contact.state ?? .ready)
    }
  }
  
  private func retrieveAndAssignContacts() {
    let retrievedContacts = ObjectManager.retrieveAll(ofType: Contact.self)
    let accountsMap = createAccountsMap()
    retrievedContacts.forEach { contact in
      accountsMap[contact.accountID]?.contactGrouper.append(contact, to: contact.state ?? .ready)
    }
  }
  
  func reconcileContactsFromSalesforce(localContacts: [Contact], salesforceContacts: [Contact]) {
    salesforceContacts.forEach { contact in
      if let matchingLocalContact = localContacts.first(where: { $0.id == contact.id }) {
        contact.mergeLocalProperties(with: matchingLocalContact)
      }
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
    guard let userId = Lifecycle.currentUser?.id else { return }
    ObjectManager.deleteAll(ofType: Account.self, with: NSPredicate(format: "ownerUserId == %d", userId))
  }
  
  func fetchAccountsFromSalesforce() {
    let accountsfromSalesforce = SFHelper.queryAccounts()
    reconcileAccountsFromSalesforce(localAccounts: accountGrouper.values, salesforceAccounts: accountsfromSalesforce)
    setAccounts(accountsfromSalesforce)
    print(accountGrouper)
  }
  
  func reconcileAccountsFromSalesforce(localAccounts: [Account], salesforceAccounts: [Account]) {
    salesforceAccounts.forEach { account in
      if let matchingLocalAccount = localAccounts.first(where: { $0.id == account.id }) {
        account.mergeLocalProperties(with: matchingLocalAccount)
      }
    }
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
  
  func endSalesforceSession() {
    SFHelper.endSession()
  }
}
