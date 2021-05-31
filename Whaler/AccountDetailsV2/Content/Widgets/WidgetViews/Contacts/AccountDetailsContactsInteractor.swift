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
  let dataChanged = PassthroughSubject<Void, Never>()
  
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
  
  ///Refetch all is a bit brutish, but works for now to reload on update notification.
  func refetchContacts() {
    subscribeToContacts(for: dataManager)
  }
  
  func subscribeToContacts(for dataManager: MainDataManager) {
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
              self?.dataChanged.send()
            })
  }
  
  func addContact(_ contact: Contact, state: WorkState, index: Int) {
    contact.state = state
    contactGrouper?.insert(contact, to: state, at: index)
    _ = repoStore.contactRepository.save([contact])
  }
  
  @discardableResult
  func removeFrom(state: WorkState, index: Int) -> Contact? {
    contactGrouper?.remove(from: state, at: index)
  }
  
  func assign(_ user: User, to contact: Contact) {
    let newEntry = ContactAssignmentEntry(contactId: contact.id,
                                          assignedBy: Lifecycle.currentUser?.id ?? "",
                                          assignedTo: user.id)
    _ = repoStore.contactAssignmentEntryRepository.save(newEntry)
    contact.assignedTo = user.id
  }
}
