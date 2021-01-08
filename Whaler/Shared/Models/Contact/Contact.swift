//
//  Contact.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/22/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import MobileCoreServices
import CoreData

final class Contact: NSObject, Codable {
  private enum CodingKeys: String, CodingKey {
    case id, accountID, salesforceID, salesforceAccountID, firstName, lastName, jobTitle, phone, email, state
  }
  
  var id: String
  var salesforceID: String?
  var accountID: String
  var salesforceAccountID: String?
  let firstName: String
  let lastName: String
  let jobTitle: String
  
  let phone: String?
  let email: String?
  
  var state: WorkState?
  
  var fullName: String {
    return firstName + " " + lastName
  }
  
  init(id: String, accountID: String, salesforceID: String?, salesforceAccountID: String?, firstName: String, lastName: String, jobTitle: String, phone: String?, email: String?, state: WorkState) {
    self.id = id
    self.accountID = accountID
    self.salesforceID = salesforceID
    self.salesforceAccountID = salesforceAccountID
    self.firstName = firstName
    self.lastName = lastName
    self.jobTitle = jobTitle
    self.phone = phone
    self.email = email
    self.state = state
  }
  
  init(dictionary: Dictionary<String, String>) {
    id = dictionary["Contact ID"] ?? ""
    accountID = dictionary["Account ID"] ?? ""
    firstName = dictionary["First Name"] ?? ""
    lastName = dictionary["Last Name"] ?? ""
    jobTitle = dictionary["Title"] ?? ""
    phone = dictionary["Phone"]
    email = dictionary["Email"]
    state = .ready
  }
  
  init(sfContact: SF.Contact, accountId: String) {
    id = ""
    salesforceID = sfContact.Id ?? ""
    self.accountID = accountId
    salesforceAccountID = sfContact.AccountId ?? ""
    firstName = sfContact.FirstName ?? ""
    lastName = sfContact.LastName ?? ""
    jobTitle = sfContact.Title ?? ""
    phone = sfContact.Phone
    email = sfContact.Email
    state = .ready
  }
  
  init(sfLead: SF.Lead, accountId: String, salesforceAccountId: String?) {
    id = ""
    salesforceID = sfLead.Id ?? ""
    self.accountID = accountId
    self.salesforceAccountID = salesforceAccountId
    firstName = sfLead.FirstName ?? ""
    lastName = sfLead.LastName ?? ""
    jobTitle = sfLead.Title ?? ""
    phone = sfLead.Phone
    email = sfLead.Email
    state = .ready
  }
  
  func mergeLocalProperties(with contact: Contact) {
    id = contact.id
    accountID = contact.accountID
    state = contact.state
  }
}

extension Contact: Identifiable {}

extension Contact: ManagedObject {
  static var entityName: String {
    return "ContactEntity"
  }
  
  convenience init(managedObject: NSManagedObject) {
    let id = managedObject.value(forKey: CodingKeys.id.rawValue) as? String ?? ""
    let accountID = managedObject.value(forKey: CodingKeys.accountID.rawValue) as? String ?? ""
    let salesforceID = managedObject.value(forKey: CodingKeys.salesforceID.rawValue) as? String ?? ""
    let salesforceAccountID = managedObject.value(forKey: CodingKeys.salesforceAccountID.rawValue) as? String ?? ""
    let firstName = managedObject.value(forKey: CodingKeys.firstName.rawValue) as? String ?? ""
    let lastName = managedObject.value(forKey: CodingKeys.lastName.rawValue) as? String ?? ""
    let jobTitle = managedObject.value(forKey: CodingKeys.jobTitle.rawValue) as? String ?? ""
    let phone = managedObject.value(forKey: CodingKeys.phone.rawValue) as? String
    let email = managedObject.value(forKey: CodingKeys.email.rawValue) as? String
    let stateString = managedObject.value(forKey: CodingKeys.state.rawValue) as? String ?? ""
    let state = WorkState(rawValue: stateString) ?? .ready
    self.init(id: id, accountID: accountID, salesforceID: salesforceID, salesforceAccountID: salesforceAccountID, firstName: firstName, lastName: lastName, jobTitle: jobTitle, phone: phone, email: email, state: state)
  }
  
  func setProperties(in managedObject: NSManagedObject) {
    managedObject.setValue(id, forKey: CodingKeys.id.rawValue)
    managedObject.setValue(accountID, forKey: CodingKeys.accountID.rawValue)
    managedObject.setValue(salesforceID, forKey: CodingKeys.salesforceID.rawValue)
    managedObject.setValue(salesforceAccountID, forKey: CodingKeys.salesforceAccountID.rawValue)
    managedObject.setValue(firstName, forKey: CodingKeys.firstName.rawValue)
    managedObject.setValue(lastName, forKey: CodingKeys.lastName.rawValue)
    managedObject.setValue(jobTitle, forKey: CodingKeys.jobTitle.rawValue)
    managedObject.setValue(phone, forKey: CodingKeys.phone.rawValue)
    managedObject.setValue(email, forKey: CodingKeys.email.rawValue)
    managedObject.setValue(state?.rawValue, forKey: CodingKeys.state.rawValue)
    if let userId = Lifecycle.currentUser?.id {
      managedObject.setValue(String(userId), forKey: "ownerUserId")
    }
  }
}

extension Contact: NSItemProviderWriting {
  static var writableTypeIdentifiersForItemProvider: [String] {
    return [(kUTTypeUTF8PlainText) as String]
  }
  
  func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
    let progress = Progress(totalUnitCount: 100)
    do {
      let data = try JSONEncoder().encode(self)
      progress.completedUnitCount = 100
      completionHandler(data, nil)
    } catch let error {
      completionHandler(nil, error)
    }
    return progress
  }
}

extension Contact: NSItemProviderReading {
  static var readableTypeIdentifiersForItemProvider: [String] {
    return [(kUTTypeUTF8PlainText) as String]
  }
  
  public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Contact {
    let decoder = JSONDecoder()
    do {
      let contact = try decoder.decode(Contact.self, from: data)
      return contact
    } catch let error {
      throw error
    }
  }
}

extension Contact: ObservableObject {}

extension Contact {
  convenience init(apiContact: ContactsQuery.Data.Contact) {
    self.init(id: apiContact.id,
              accountID: apiContact.accountId ?? "",
              salesforceID: apiContact.salesforceId,
              salesforceAccountID: nil,
              firstName: "",
              lastName: "",
              jobTitle: "",
              phone: nil,
              email: nil,
              state: .ready)
  }
}

extension Contact: RepoStorable {}
