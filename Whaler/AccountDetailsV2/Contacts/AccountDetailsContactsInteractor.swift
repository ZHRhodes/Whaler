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
  lazy var contactGrouper = Grouper<WorkState, Contact>(groups: self.contactStates)
  var contactBeingAssigned: Contact?
  var contactsCancellable: AnyCancellable?
  
  init(dataManager: MainDataManager) {
    self.dataManager = dataManager
  }
  
  func subscribeToContacts(for dataManager: MainDataManager, contactsUpdated: @escaping ([Contact]) -> Void) {
    guard let lastSelected = dataManager.lastSelected else {
      Log.error("Arrived at account details without lastSelected.")
      return
    }
    let account = dataManager.accountGrouper[lastSelected.state][lastSelected.index]
    account.resetContacts()
    let repo = repoStore.contactRepository
    let request = ContactAllDataRequest(account: account)
    contactsCancellable = repo
      .fetchAll(with: request)
      .sink(receiveCompletion: { _ in },
            receiveValue: { (contacts) in
              account.resetContacts()
              contacts.forEach { contact in
                account.contactGrouper.append(contact, to: contact.state ?? .ready)
              }
              contactsUpdated(contacts)
    })
  }
  
  func assign(_ user: User, to contact: Contact) {
    Log.info("Assigned contact \(contact.id) to user \(user.id)")
  }
}
