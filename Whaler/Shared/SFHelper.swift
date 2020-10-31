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
  static func queryAccounts() -> [Account] {
    let soql = "SELECT id, name, type, industry, annualRevenue, billingCity, billingState, phone, website, numberOfEmployees, ownerId, description from Account WHERE (NOT type like 'Customer%') AND OwnerId = '\(SFSession.id ?? "")'"
    var sfAccounts = [SF.Account]()
    do {
      sfAccounts = try SF.query(soql)
    } catch let error {
      print(error)
    }

    return sfAccounts.map(Account.init)
  }
  
  static func queryContacts(accountId: String,
                            salesforceAccountId: String,
                            accountName: String?) -> [Contact] {
    let sfContacts: [SF.Contact]
    do {
       sfContacts = try SF.query("SELECT id, accountId, firstName, lastName, title, phone, email from Contact WHERE AccountId = '\(salesforceAccountId)'")
    } catch let error {
      print(error)
      sfContacts = []
    }
    
    let sfLeads: [SF.Lead]
    do { //WHERE TravelBank LIKE 'TravelBank HR'
      sfLeads = try SF.query("SELECT id, company, firstName, lastName, title, phone, email from Lead WHERE Company LIKE '%\(accountName ?? "")%'")
    } catch let error {
      print(error)
      sfLeads = []
    }
    
    var contacts = sfLeads.map { Contact(sfLead: $0,
                                         accountId: accountId,
                                         salesforceAccountId: salesforceAccountId) }
    
    contacts.append(contentsOf: sfContacts.map { Contact(sfContact: $0, accountId: accountId) })
    return contacts
  }
  
  static func queryPossibleIndustries() -> [String] {
    let soql = "Select Industry from Account group by Industry"
    var industries = [SF.IndustryGroup]()
    do {
      industries = try SF.query(soql)
    } catch let error {
      print(error)
    }
    return industries.compactMap { $0.Industry }
  }
  
  static func queryPossibleOwners() -> [String] {
    let soql = "Select Owner.Name from Account group by Owner.Name"
    var ownerNames = [SF.OwnerNameGroup]()
    do {
      ownerNames = try SF.query(soql)
    } catch let error {
      print(error)
    }
    return ownerNames.compactMap { $0.Name }
  }
  
  static func queryPossibleBillingStates() -> [String] {
    let soql = "Select BillingState from Account group by BillingState"
    var billingStates = [SF.BillingStateGroup]()
    do {
      billingStates = try SF.query(soql)
    } catch let error {
      print(error)
    }
    return billingStates.compactMap { $0.BillingState }
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
      let idUrl = url?.fragmentValueOf("id")?.removingPercentEncoding
      if let id = idUrl?.split(separator: "/").last {
        SFSession.id = String(id)
      }
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
