//
//  MainInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import AuthenticationServices

protocol MainInteractorData: class {
  var accountGrouper: Grouper<WorkState, Account> {get set}
}

class MainInteractor: MainInteractorData {
  lazy var accountGrouper = Grouper<WorkState, Account>(groups: self.accountStates)
  lazy var accountStates = WorkState.allCases
  var accountBeingAssigned: Account?
  weak var viewController: MainViewController?
  
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
    var retrievedContacts = [Contact]()
    if let salesforceId = account.salesforceID {
      retrievedContacts = SFHelper.queryContacts(accountId: account.id,
                                                     salesforceAccountId: salesforceId,
                                                     accountName: account.name)
    }
    let localContacts = ObjectManager.retrieveAll(ofType: Contact.self)
    reconcileContactsFromSalesforce(localContacts: localContacts, salesforceContacts: retrievedContacts)
    retrievedContacts.forEach { contact in
      account.contactGrouper.append(contact, to: contact.state ?? .ready)
    }
    DispatchQueue.global(qos: .utility).async {
      let input = retrievedContacts.map { NewContact(id: $0.id,
                                                     firstName: $0.firstName,
                                                     lastName: $0.lastName,
                                                     jobTitle: $0.jobTitle,
                                                     state: $0.state?.rawValue,
                                                     email: $0.email,
                                                     phone: $0.phone,
                                                     accountId: $0.accountID)}
      Graph.shared.apollo.perform(mutation: SaveContactsMutation(input: input))
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
    let input = accountsfromSalesforce.map { NewAccount(id: $0.id,
                                                        salesforceId: $0.salesforceID,
                                                        name: $0.name,
                                                        ownerId: $0.ownerID,
                                                        industry: $0.industry,
                                                        description: $0.description,
                                                        numberOfEmployees: $0.numberOfEmployees,
                                                        annualRevenue: $0.annualRevenue,
                                                        billingCity: $0.billingCity,
                                                        billingState: $0.billingState,
                                                        phone: $0.phone,
                                                        website: $0.website,
                                                        type: $0.type,
                                                        state: $0.state?.rawValue,
                                                        notes: $0.notes) }
    Graph.shared.apollo.perform(mutation: SaveAccountsMutation(input: input)) { [weak self] result in
      guard let data = try? result.get().data else { return }
      let accounts = data.saveAccounts.map(Account.init)
      self?.setAccounts(accounts)
      self?.viewController?.reloadCollection()
      AccountsWorker().fetchAccountsFromAPI { (accounts) in
        print(accounts)
      }
    }
    print(accountGrouper)
  }
  
  //will newly added in salesforce accounts save to cache in whaler? or is that only done on authentication?
  
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
  
  func assign(_ user: User, to account: Account) {
    print(user, account)
  }
}
