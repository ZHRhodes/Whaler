//
//  SFHelper.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/21/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import AuthenticationServices

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
  
  static func makeAuthenticationSession(completion: @escaping VoidClosure) -> ASWebAuthenticationSession? {
    let urlString = #"https://login.salesforce.com/services/oauth2/authorize?response_type=token&client_id=3MVG9Kip4IKAZQEVUyT0t2bh34B.GSy._2rVDX_MVJ7a3GyUtHsAGG2GZU843.Gajp7AusaDdCEero1UuAJwK&redirect_uri=getwhaler://salesforce_connect"#
    guard let url = URL(string: urlString) else { return nil }
    let session = ASWebAuthenticationSession(url: url, callbackURLScheme: "getwhaler") { (url, error) in
      if let error = error {
        print(error)
      }
      SFSession.accessToken = url?.fragmentValueOf("access_token")?.removingPercentEncoding
      SFSession.refreshToken = url?.fragmentValueOf("refresh_token")?.removingPercentEncoding
      DispatchQueue.main.sync {
        completion()
      }
    }
    
    return session
  }
  
  static func endSession() {
    SFSession.accessToken = nil
    SFSession.refreshToken = nil
  }
}
