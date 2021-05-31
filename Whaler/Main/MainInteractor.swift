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
import Starscream

//temporary location for this -- inject for testing
let repoStore = RepoStore()

//TODO: refactor this data management. There's a lot I dont like here, but I'm prioritizing making what I have resuable across accounts and contacts for now.

protocol MainDataManager: class {
  var accountGrouper: Grouper<WorkState, Account> { get set }
  var lastSelected: (state: WorkState, index: Int)? { get }
}

class MainInteractor: MainDataManager {
  lazy var accountGrouper = Grouper<WorkState, Account>(groups: self.accountStates)
  var lastSelected: (state: WorkState, index: Int)?
  lazy var accountStates = WorkState.allCases
  var accountBeingAssigned: Account?
  weak var viewController: MainViewController?
  private let accountsHelper = AccountsHelper()
  private let contactsHelper = ContactsHelper()
  var accountsCancellable: AnyCancellable?
  let dataChanged = PassthroughSubject<Void, Never>()
  private var socket: WebSocketClient?
  
  func hasAccounts() -> Bool {
    return !accountGrouper.hasNoValues
  }
  
  var hasSalesforceTokens: Bool {
    SFSession.loadCachedSFSession()
    return SFSession.hasTokens()
  }
  
  init() {
    retrieveAccounts()
    setupSocketForUpdates()
  }
  
  func setupSocketForUpdates() {
    //using org id as a quick and dirty way to catch any possible account change
    guard let orgId = Lifecycle.currentUser?.organizationId else {
      Log.error("Can't setup main socket without org id.")
      return
    }
    socket?.disconnect()
    socket = WebSocketManager.shared.registerConnection(id: orgId)
    WebSocketManager.shared.info(for: socket)?.delegates.add(delegate: self)
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
  
  private func retrieveAndAssignContacts() {
    let retrievedContacts = ObjectManager.retrieveAll(ofType: Contact.self)
    let accountsMap = createAccountsMap()
    retrievedContacts.forEach { contact in
      accountsMap[contact.accountID]?.contactGrouper.append(contact, to: contact.state ?? .ready)
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
    
  func getAccounts() {
    let repo = repoStore.accountRepository
    accountsCancellable = repo.publisher.dropFirst().sink { _ in }
      receiveValue: { (accounts) in
      self.setAccounts(accounts)
      self.dataChanged.send()
      Log.info(String(reflecting: self.accountGrouper))
    }
    fetchAllAccounts()
  }
  
  func fetchAllAccounts() {
    repoStore.accountRepository.fetchAll()
  }
  
  //TODO: will newly added in salesforce accounts save to cache in whaler? or is that only done on authentication?
  
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
      Log.error("Failed to refresh Salesforce session. \(error)")
      completion(false)
    }
  }
  
  func endSalesforceSession() {
    SFHelper.endSession()
  }
  
  func assign(_ user: User, to account: Account) {
    let newEntry = AccountAssignmentEntry(accountId: account.id,
                                          assignedBy: Lifecycle.currentUser?.id ?? "",
                                          assignedTo: user.id)
    _ = repoStore.accountAssignmentEntryRepository.save(newEntry)
    account.assignedTo = user.id
  }
}

extension MainInteractor: LiteWebSocketDelegate {
  func didReceiveMessage(_ message: SocketMsg, socket: WebSocketClient) {
    switch message {
    case .resourceUpdated(let update):
      guard let orgId = Lifecycle.currentUser?.organizationId else { return }
      if update.resourceId == orgId && update.senderId != clientId {
        fetchAllAccounts()
      }
    default:
      break
    }
  }
  
  func connectionEstablished(socket: WebSocketClient) {}
}
