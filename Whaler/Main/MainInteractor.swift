//
//  MainInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import AuthenticationServices
import Combine

protocol MainInteractorData: class {
  var accountGrouper: Grouper<WorkState, Account> {get set}
}

class MainInteractor: MainInteractorData {
  lazy var accountGrouper = Grouper<WorkState, Account>(groups: self.accountStates)
  lazy var accountStates = WorkState.allCases
  var accountBeingAssigned: Account?
  weak var viewController: MainViewController?
  private let accountsHelper = AccountsHelper()
  private let contactsHelper = ContactsHelper()
  
  func hasAccounts() -> Bool {
    return !accountGrouper.hasNoValues
  }
  
  var hasSalesforceTokens: Bool {
    SFSession.loadCachedSFSession()
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
  
  func retrieveAccounts() {
    guard let userId = Lifecycle.currentUser?.id else { return }
    let predicate = NSPredicate(format: "ownerUserId == %d", userId)
    let retrievedAccounts = ObjectManager.retrieveAll(ofType: Account.self, with: predicate)
    Log.info(String(reflecting: retrievedAccounts))
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
  
  func getContacts(for account: Account, completion: @escaping () -> Void) {
    account.resetContacts()
    contactsHelper.fetchContactsFromAPI(accountID: account.id) { (apiContacts) in
      Log.info(apiContacts?.reduce("", { $0 + " " + $1.id }) ?? "")
      guard let apiContacts = apiContacts else {
        Log.error("Failed to fetch contacts from API")
        return
      }
      
      var retrievedContacts = [Contact]()
      if let salesforceId = account.salesforceID {
        retrievedContacts = self.contactsHelper.fetchContactsFromSalesforce(accountId: account.id,
                                                                            salesforceAccountId: salesforceId,
                                                                            accountName: account.name)
      }
      
      self.reconcileContactsFromSalesforce(localContacts: apiContacts, salesforceContacts: retrievedContacts)
      self.contactsHelper.saveContactsToAPI(retrievedContacts) { (contacts) in
        contacts.forEach { contact in
          account.contactGrouper.append(contact, to: contact.state ?? .ready)
        }
        completion()
      }
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
      if let matchingLocalContact = localContacts.first(where: { $0.salesforceID == contact.salesforceID }) {
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
  
  //move to share
  let repoStore = RepoStore()
  var cancellable: AnyCancellable?
  
  func getAccounts() {
    let repo = repoStore.accountRepository
    repo.fetchAll()
    cancellable = repo.publisher.sink { _ in } receiveValue: { (accounts) in
      self.setAccounts(accounts)
      self.viewController?.reloadCollection()
      Log.info(String(reflecting: self.accountGrouper))
    }
  }
  
  //will newly added in salesforce accounts save to cache in whaler? or is that only done on authentication?
  
  func reconcileAccountsFromSalesforce(localAccounts: [Account], salesforceAccounts: [Account]) {
    salesforceAccounts.forEach { account in
      if let matchingLocalAccount = localAccounts.first(where: { $0.salesforceID == account.salesforceID }) {
        account.mergeLocalProperties(with: matchingLocalAccount)
      }
    }
  }
  
  func makeSFAuthenticationSession(completion: @escaping VoidClosure) -> ASWebAuthenticationSession? {
    let session = SFHelper.makeAuthenticationSession { [weak self] in
      self?.getAccounts()
      completion()
    }
    
    return session
  }
  
  func refreshSalesforceSession(completion: @escaping BoolClosure) {
    do {
      try SF.refreshAccessToken()
      completion(true)
    } catch let error {
      Log.error("Failed to refresh Salesforce session.")
      completion(false)
    }
  }
  
  func endSalesforceSession() {
    SFHelper.endSession()
  }
  
  func assign(_ user: User, to account: Account) {
    Log.info("Assigned account \(account.id) to user \(user.id)")
  }
}
