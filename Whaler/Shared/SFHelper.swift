//
//  SFHelper.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/21/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

class SFHelper {
  static func queryContacts(accountId: String?, accountName: String?) -> [Contact] {
    let sfContacts: [SF.Contact]
    do {
       sfContacts = try SF.query("SELECT id, accountId, firstName, lastName, title, phone, email from Contact WHERE AccountId = '\(accountId ?? "")'")
    } catch let error {
      print(error)
      sfContacts = []
    }
    
    let sfLeads: [SF.Lead]
    do {
      sfLeads = try SF.query("SELECT id, company, firstName, lastName, title, phone, email from Lead WHERE Company LIKE '%\(accountName ?? "")%'")
    } catch let error {
      print(error)
      sfLeads = []
    }
    
    var contacts = sfLeads.map { Contact(sfLead: $0, accountId: accountId ?? "") }
    
    contacts.append(contentsOf: sfContacts.map(Contact.init))
    return contacts
  }
}
