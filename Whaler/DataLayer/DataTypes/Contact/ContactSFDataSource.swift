//
//  ContactSFDataStore.swift
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

struct ContactSFDataSource {
  func fetchAll(with dataRequest: ContactAllDataRequest) -> AnyPublisher<[Contact], RepoError> {
    return Future<[Contact], RepoError> { promise in
      let account = dataRequest.account
      guard let salesforceID = account.salesforceID else {
        let message = "Cannot fetch SF contacts for an account without a salesforceID"
        let error = RepoError(reason: message, humanReadableMessage: nil)
        return promise(.failure(error))
      }
      let contactHelper = ContactsHelper()
      let contacts = contactHelper.fetchContactsFromSalesforce(accountId: account.id,
                                                salesforceAccountId: salesforceID,
                                                accountName: account.name)
      promise(.success(contacts))
    }.eraseToAnyPublisher()
  }
}
