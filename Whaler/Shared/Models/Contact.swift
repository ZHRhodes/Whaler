//
//  Contact.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/22/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct Contact: Codable {
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
