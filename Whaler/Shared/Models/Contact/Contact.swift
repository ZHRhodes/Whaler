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
    case id, accountID, firstName, lastName, title, phone, email, state
  }
  
  let id: String
  let accountID: String
  let firstName: String
  let lastName: String
  let title: String
  
  let phone: String?
  let email: String?
  
  var state: WorkState
  
  var fullName: String {
    return firstName + " " + lastName
  }
  
  init(id: String, accountID: String, firstName: String, lastName: String, title: String, phone: String?, email: String?, state: WorkState) {
    self.id = id
    self.accountID = accountID
    self.firstName = firstName
    self.lastName = lastName
    self.title = title
    self.phone = phone
    self.email = email
    self.state = state
  }
  
  init(dictionary: Dictionary<String, String>) {
    id = dictionary["Contact ID"] ?? ""
    accountID = dictionary["Account ID"] ?? ""
    firstName = dictionary["First Name"] ?? ""
    lastName = dictionary["Last Name"] ?? ""
    title = dictionary["Title"] ?? ""
    phone = dictionary["Phone"]
    email = dictionary["Email"]
    state = .ready
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
    let firstName = managedObject.value(forKey: CodingKeys.firstName.rawValue) as? String ?? ""
    let lastName = managedObject.value(forKey: CodingKeys.lastName.rawValue) as? String ?? ""
    let title = managedObject.value(forKey: CodingKeys.title.rawValue) as? String ?? ""
    let phone = managedObject.value(forKey: CodingKeys.phone.rawValue) as? String
    let email = managedObject.value(forKey: CodingKeys.email.rawValue) as? String
    let stateString = managedObject.value(forKey: CodingKeys.state.rawValue) as? String ?? ""
    let state = WorkState(rawValue: stateString) ?? .ready
    self.init(id: id, accountID: accountID, firstName: firstName, lastName: lastName, title: title, phone: phone, email: email, state: state)
  }
  
  func setProperties(in managedObject: NSManagedObject) {
    managedObject.setValue(id, forKey: CodingKeys.id.rawValue)
    managedObject.setValue(accountID, forKey: CodingKeys.accountID.rawValue)
    managedObject.setValue(firstName, forKey: CodingKeys.firstName.rawValue)
    managedObject.setValue(lastName, forKey: CodingKeys.lastName.rawValue)
    managedObject.setValue(title, forKey: CodingKeys.title.rawValue)
    managedObject.setValue(phone, forKey: CodingKeys.phone.rawValue)
    managedObject.setValue(email, forKey: CodingKeys.email.rawValue)
    managedObject.setValue(state.rawValue, forKey: CodingKeys.state.rawValue)
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
