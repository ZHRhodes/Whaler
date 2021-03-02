//
//  AccountDetailsContactsInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/21/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class AccountDetailsContactsInteractor {
  let dataManager: MainDataManager
  let contactStates = WorkState.contactsCases
  var contactGrouper: Grouper<WorkState, Contact>?
  var contactBeingAssigned: Contact?
  var contactsCancellable: AnyCancellable?
  
  var account: Account {
    if let lastSelected = dataManager.lastSelected {
      return dataManager.accountGrouper[lastSelected.state][lastSelected.index]
    } else {
      Log.error("Arrived at account details without lastSelected.")
      return Account()
    }
  }
  
  init(dataManager: MainDataManager) {
    self.dataManager = dataManager
  }
  
  func subscribeToContacts(for dataManager: MainDataManager, contactsUpdated: @escaping ([Contact]) -> Void) {
    let repo = repoStore.contactRepository
    let request = ContactAllDataRequest(account: account)
    contactsCancellable = repo
      .fetchAll(with: request)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] (contacts) in
              guard let strongSelf = self else { return }
              strongSelf.contactGrouper = .init(groups: strongSelf.contactStates)
              contacts.forEach { contact in
                strongSelf.contactGrouper?.append(contact, to: contact.state ?? .ready)
              }
              contactsUpdated(contacts)
    })
  }
  
  func addContact(_ contact: Contact, state: WorkState, index: Int) {
    contact.state = state
    contactGrouper?.insert(contact, to: state, at: index)
  }
  
  @discardableResult
  func removeFrom(state: WorkState, index: Int) -> Contact? {
    contactGrouper?.remove(from: state, at: index)
  }
  
  func assign(_ user: User, to contact: Contact) {
    Log.info("Assigned contact \(contact.id) to user \(user.id)")
  }
}
