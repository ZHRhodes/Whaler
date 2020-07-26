//
//  Contact.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/22/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import CoreData

struct Contact: Codable {
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
    state = WorkState.allCases.randomElement()!
  }
}

extension Contact: Identifiable {}

extension Contact: ManagedObject {
  static var entityName: String {
    return "ContactEntity"
  }
  
  init(managedObject: NSManagedObject) {
    self.id = managedObject.value(forKey: CodingKeys.id.rawValue) as? String ?? ""
    self.accountID = managedObject.value(forKey: CodingKeys.accountID.rawValue) as? String ?? ""
    self.firstName = managedObject.value(forKey: CodingKeys.firstName.rawValue) as? String ?? ""
    self.lastName = managedObject.value(forKey: CodingKeys.lastName.rawValue) as? String ?? ""
    self.title = managedObject.value(forKey: CodingKeys.title.rawValue) as? String ?? ""
    self.phone = managedObject.value(forKey: CodingKeys.phone.rawValue) as? String
    self.email = managedObject.value(forKey: CodingKeys.email.rawValue) as? String
    self.state = WorkState.allCases.randomElement()!
//    self.state = managedObject.value(forKey: CodingKeys.state.rawValue) as? String ?? ""
  }
  
  func setProperties(in managedObject: NSManagedObject) {
    managedObject.setValue(id, forKey: CodingKeys.id.rawValue)
    managedObject.setValue(accountID, forKey: CodingKeys.accountID.rawValue)
    managedObject.setValue(firstName, forKey: CodingKeys.firstName.rawValue)
    managedObject.setValue(lastName, forKey: CodingKeys.lastName.rawValue)
    managedObject.setValue(title, forKey: CodingKeys.title.rawValue)
    managedObject.setValue(phone, forKey: CodingKeys.phone.rawValue)
    managedObject.setValue(email, forKey: CodingKeys.email.rawValue)
//    managedObject.setValue(state, forKey: CodingKeys.state.rawValue)
  }
}
