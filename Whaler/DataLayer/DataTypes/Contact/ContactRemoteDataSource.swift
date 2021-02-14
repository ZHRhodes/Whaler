//
//  ContactRemoteDataSource.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/12/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

struct ContactRemoteDataSource {
  func fetchAll(with dataRequest: ContactAllDataRequest) -> AnyPublisher<[Contact], RepoError> {
    return Future<[Contact], RepoError> { promise in
      let contactHelper = ContactsHelper()
      contactHelper.fetchContactsFromAPI(accountID: dataRequest.account.id) { (contacts) in
        promise(.success(contacts ?? []))
      }
    }.eraseToAnyPublisher()
  }
  
  func saveAll(_ new: [Contact]) -> AnyPublisher<[Contact], RepoError> {
    return Future<[Contact], RepoError> { promise in
      let contactsHelper = ContactsHelper()
      contactsHelper.saveContactsToAPI(new) { (contacts) in
        promise(.success(contacts))
      }
    }.eraseToAnyPublisher()
  }
}
