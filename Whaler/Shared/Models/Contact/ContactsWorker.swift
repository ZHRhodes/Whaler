//
//  ContactsWorker.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/29/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct ContactsHelper {
  func fetchContactsFromSalesforce(accountId: String,
                                   salesforceAccountId: String,
                                   accountName: String?) -> [Contact] {
    return SFHelper.queryContacts(accountId: accountId,
                                  salesforceAccountId: salesforceAccountId,
                                  accountName: accountName)
  }
  
  func fetchContactsFromAPI(accountID: String, completion: @escaping ([Contact]?) -> Void) {
    Graph.shared.apollo.fetch(query: ContactsQuery(accountID: accountID)) { result in
      guard let data = try? result.get().data else {
        completion(nil)
        return
      }
      completion(data.contacts.map(Contact.init))
    }
  }
  
  func saveContactsToAPI(_ contacts: [Contact], completion: @escaping ([Contact]) -> Void) {
    let input = contacts.map { NewContact(id: $0.id,
                                          salesforceId: $0.salesforceID,
                                          firstName: $0.firstName,
                                          lastName: $0.lastName,
                                          jobTitle: $0.jobTitle,
                                          state: $0.state?.rawValue,
                                          email: $0.email,
                                          phone: $0.phone,
                                          accountId: $0.accountID)}
    Graph.shared.apollo.perform(mutation: SaveContactsMutation(input: input)) { result in
      guard let data = try? result.get().data else { return }
      completion(contacts) //this isn't actually returning the newly saved contacts yet
    }
  }
}
