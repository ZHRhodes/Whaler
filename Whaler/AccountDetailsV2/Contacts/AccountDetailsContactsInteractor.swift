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
  private let account: Account
  let contactStates = WorkState.contactsCases
  lazy var contactGrouper = Grouper<WorkState, Contact>(groups: self.contactStates)
  var contactBeingAssigned: Contact?
  var contactsCancellable: AnyCancellable?
  
  init(account: Account) {
    self.account = account
  }
  
  func subscribeToContacts(for account: Account, contactsUpdated: @escaping ([Contact]) -> Void) {
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
