//
//  ContactDataStore.swift
//  Whaler
//
//  Created by Zachary Rhodes on 1/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

struct ContactAllDataRequest {
  let account: Account
}

protocol ContactDataSource {
  func fetchAll(with dataRequest: ContactAllDataRequest) -> AnyPublisher<[Contact], Error>
  func saveAll(_ new: [Contact]) -> AnyPublisher<[Contact], Error>
}

struct ContactRemoteDataSource: ContactDataSource {
  func fetchAll(with dataRequest: ContactAllDataRequest) -> AnyPublisher<[Contact], Error> {
    return Future<[Contact], Error> { promise in
      let contactHelper = ContactsHelper()
      contactHelper.fetchContactsFromAPI(accountID: dataRequest.account.id) { (contacts) in
        promise(.success(contacts ?? []))
      }
    }.eraseToAnyPublisher()
  }
  
  func saveAll(_ new: [Contact]) -> AnyPublisher<[Contact], Error> {
    return Future<[Contact], Error> { promise in
      let contactsHelper = ContactsHelper()
      contactsHelper.saveContactsToAPI(new) { (contacts) in
        promise(.success(contacts))
      }
    }.eraseToAnyPublisher()
  }
}

struct ContactSFDataSource: ContactDataSource {
  func fetchAll(with dataRequest: ContactAllDataRequest) -> AnyPublisher<[Contact], Error> {
    return Future<[Contact], Error> { promise in
      let account = dataRequest.account
      guard let salesforceID = account.salesforceID else {
        let message = "Cannot fetch SF contacts for an account without a salesforceID"
        return promise(.failure(message))
      }
      let contactHelper = ContactsHelper()
      let contacts = contactHelper.fetchContactsFromSalesforce(accountId: account.id,
                                                salesforceAccountId: salesforceID,
                                                accountName: account.name)
      promise(.success(contacts))
    }.eraseToAnyPublisher()
  }
  
  func saveAll(_ new: [Contact]) -> AnyPublisher<[Contact], Error> {
    fatalError("Not implemented")
  }
}
