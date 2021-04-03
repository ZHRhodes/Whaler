//
//  Account.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import MobileCoreServices
import CoreData

final class Account: NSObject, Codable, IdProviding {
  private enum CodingKeys: String, CodingKey {
    case id, salesforceOwnerID, name, salesforceID, industry, numberOfEmployees, annualRevenue, billingCity, billingState, phone, website, type, accountDescription, state, contactGrouper, notes
  }
  
  var id: String
  var salesforceOwnerID: String?
  var name: String
  var salesforceID: String?
  let industry: String?
  let numberOfEmployees: String?
  let annualRevenue: String?
  let billingCity: String?
  let billingState: String?
  var contactsCount: String {
    return String(contactGrouper.values.count)
  }
  let phone: String?
  let website: String?
  let type: String?
  let accountDescription: String?
  
  var state: WorkState?
  var notes: String?
  
  var contactGrouper = Grouper<WorkState, Contact>(groups: WorkState.allCases)
  
  override init() {
    id = ""
    salesforceOwnerID = ""
    name = ""
    salesforceID = ""
    industry = ""
    numberOfEmployees = ""
    annualRevenue = ""
    billingCity = ""
    billingState = ""
    phone = ""
    website = ""
    type = ""
    accountDescription = ""
    super.init()
  }
  
  init(id: String, salesforceOwnerID: String?, name: String, salesforceID: String?, industry: String?, numberOfEmployees: String?, annualRevenue: String?, billingCity: String?, billingState: String?, phone: String?, website: String?, type: String?, accountDescription: String?, state: WorkState?, contactGrouper: Grouper<WorkState, Contact>? = nil, notes: String?) {
    self.id = id
    self.salesforceOwnerID = salesforceOwnerID
    self.name = name
    self.salesforceID = salesforceID
    self.industry = industry
    self.numberOfEmployees = numberOfEmployees
    self.annualRevenue = annualRevenue
    self.billingCity = billingCity
    self.billingState = billingState
    self.phone = phone
    self.website = website
    self.type = type
    self.accountDescription = accountDescription
    self.state = state
    self.notes = notes
    super.init()
    contactGrouper.map { self.contactGrouper = $0 }
  }
  
  init(dictionary: Dictionary<String, String>) {
    id = "" //will this mess up local caching?
    salesforceID = dictionary["Account ID"] ?? ""
//    ownerID = dictionary["Account Owner"] ?? ""
    name = dictionary["Account Name"] ?? ""
    industry = dictionary["Industry"]
    numberOfEmployees = dictionary["Employees"]
    annualRevenue = dictionary["Annual Revenue"]
    billingCity = dictionary["Billing City"]
    billingState = dictionary["Billing State/Province"]
    phone = dictionary["Account: Phone"]
    website = dictionary["Website"]
    type = dictionary["Type"]
    accountDescription = dictionary["Account Description"]
  }
  
  init(sfAccount: SF.Account) {
    id = ""
    salesforceID = sfAccount.Id ?? ""
    salesforceOwnerID = sfAccount.OwnerId ?? ""
    name = sfAccount.Name ?? ""
    industry = sfAccount.Industry
    numberOfEmployees = String(sfAccount.NumberOfEmployees ?? 0)
    annualRevenue = String(sfAccount.AnnualRevenue ?? 0)
    billingCity = sfAccount.BillingCity
    billingState = sfAccount.BillingState
    phone = sfAccount.Phone
    website = sfAccount.Website
    type = sfAccount.Type
    accountDescription = sfAccount.Description
  }
  
  func resetContacts() {
    contactGrouper.resetValues()
  }
}

protocol ManagedObject {
  var id: String { get }
  static var entityName: String { get }
  init(managedObject: NSManagedObject)
  func setProperties(in managedObject: NSManagedObject)
}

extension Account: ManagedObject {
  static var entityName: String {
    return "AccountEntity"
  }
  
  convenience init(managedObject: NSManagedObject) {
    let id = managedObject.value(forKey: CodingKeys.id.rawValue) as? String ?? ""
    let name = managedObject.value(forKey: CodingKeys.name.rawValue) as? String ?? ""
    let salesforceID = managedObject.value(forKey: CodingKeys.salesforceID.rawValue) as? String ?? ""
    let salesforceOwnerID = managedObject.value(forKey: CodingKeys.salesforceOwnerID.rawValue) as? String ?? ""
    let industry = managedObject.value(forKey: CodingKeys.industry.rawValue) as? String
    let numberOfEmployees = managedObject.value(forKey: CodingKeys.numberOfEmployees.rawValue) as? String
    let annualRevenue = managedObject.value(forKey: CodingKeys.annualRevenue.rawValue) as? String
    let billingCity = managedObject.value(forKey: CodingKeys.billingCity.rawValue) as? String
    let billingState = managedObject.value(forKey: CodingKeys.billingState.rawValue) as? String
    let phone = managedObject.value(forKey: CodingKeys.phone.rawValue) as? String
    let website = managedObject.value(forKey: CodingKeys.website.rawValue) as? String
    let type = managedObject.value(forKey: CodingKeys.type.rawValue) as? String
    let accountDescription = managedObject.value(forKey: CodingKeys.accountDescription.rawValue) as? String
    let stateString = managedObject.value(forKey: CodingKeys.state.rawValue) as? String ?? ""
    let state = WorkState(rawValue: stateString) ?? .ready
    let notes = managedObject.value(forKey: CodingKeys.notes.rawValue) as? String ?? ""
    self.init(id: id, salesforceOwnerID: salesforceOwnerID, name: name, salesforceID: salesforceID, industry: industry, numberOfEmployees: numberOfEmployees, annualRevenue: annualRevenue, billingCity: billingCity, billingState: billingState, phone: phone, website: website, type: type, accountDescription: accountDescription, state: state, notes: notes)
  }
  
  func setProperties(in managedObject: NSManagedObject) {
    managedObject.setValue(id, forKey: CodingKeys.id.rawValue)
    managedObject.setValue(name, forKey: CodingKeys.name.rawValue)
    managedObject.setValue(salesforceID, forKey: CodingKeys.salesforceID.rawValue)
    managedObject.setValue(salesforceOwnerID, forKey: CodingKeys.salesforceOwnerID.rawValue)
    managedObject.setValue(industry, forKey: CodingKeys.industry.rawValue)
    managedObject.setValue(numberOfEmployees, forKey: CodingKeys.numberOfEmployees.rawValue)
    managedObject.setValue(annualRevenue, forKey: CodingKeys.annualRevenue.rawValue)
    managedObject.setValue(billingCity, forKey: CodingKeys.billingCity.rawValue)
    managedObject.setValue(billingState, forKey: CodingKeys.billingState.rawValue)
    managedObject.setValue(phone, forKey: CodingKeys.phone.rawValue)
    managedObject.setValue(website, forKey: CodingKeys.website.rawValue)
    managedObject.setValue(type, forKey: CodingKeys.type.rawValue)
    managedObject.setValue(accountDescription, forKey: CodingKeys.accountDescription.rawValue)
    managedObject.setValue(state?.rawValue, forKey: CodingKeys.state.rawValue)
    managedObject.setValue(notes, forKey: CodingKeys.notes.rawValue)
    if let userId = Lifecycle.currentUser?.id {
      managedObject.setValue(String(userId), forKey: "ownerUserId")
    }
  }
}

extension Account: NSItemProviderWriting {
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

extension Account: NSItemProviderReading {
  static var readableTypeIdentifiersForItemProvider: [String] {
    return [(kUTTypeUTF8PlainText) as String]
  }
  
  public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Account {
    let decoder = JSONDecoder()
    do {
      let account = try decoder.decode(Account.self, from: data)
      return account
    } catch let error {
      throw error
    }
  }
}

extension Account {
  override var description: String {
    return "<Whaler.Account: \(name)>"
  }
}

extension Account {
  convenience init(savedAccount: SaveAccountsMutation.Data.SaveAccount) {
    let state = savedAccount.state.map(WorkState.init) ?? WorkState.ready
    self.init(id: savedAccount.id,
              salesforceOwnerID: savedAccount.salesforceOwnerId,
              name: savedAccount.name,
              salesforceID: savedAccount.salesforceId,
              industry: savedAccount.industry,
              numberOfEmployees: savedAccount.numberOfEmployees,
              annualRevenue: savedAccount.annualRevenue,
              billingCity: savedAccount.billingCity,
              billingState: savedAccount.billingState,
              phone: savedAccount.phone,
              website: savedAccount.website,
              type: savedAccount.type,
              accountDescription: savedAccount.description,
              state: state,
              contactGrouper: nil,
              notes: savedAccount.notes)
  }
}

extension Account {
  convenience init(trackedAccount: ApplyAccountTrackingChangesMutation.Data.TrackedAccount) {
    let state = trackedAccount.state.map(WorkState.init) ?? WorkState.ready
    self.init(id: trackedAccount.id,
              salesforceOwnerID: trackedAccount.salesforceOwnerId,
              name: trackedAccount.name,
              salesforceID: trackedAccount.salesforceId,
              industry: trackedAccount.industry,
              numberOfEmployees: trackedAccount.numberOfEmployees,
              annualRevenue: trackedAccount.annualRevenue,
              billingCity: trackedAccount.billingCity,
              billingState: trackedAccount.billingState,
              phone: trackedAccount.phone,
              website: trackedAccount.website,
              type: trackedAccount.type,
              accountDescription: trackedAccount.description,
              state: state,
              contactGrouper: nil,
              notes: trackedAccount.notes)
  }
}

extension Account {
  convenience init(apiAccount: AccountsQuery.Data.Account) {
    self.init(id: apiAccount.id,
              salesforceOwnerID: apiAccount.salesforceOwnerId,
              name: apiAccount.name,
              salesforceID: apiAccount.salesforceId,
              industry: apiAccount.industry,
              numberOfEmployees: apiAccount.numberOfEmployees,
              annualRevenue: apiAccount.annualRevenue,
              billingCity: apiAccount.billingCity,
              billingState: apiAccount.billingState,
              phone: apiAccount.phone,
              website: apiAccount.website,
              type: apiAccount.type,
              accountDescription: apiAccount.description,
              state: WorkState.init(from: apiAccount.state),
              contactGrouper: nil,
              notes: apiAccount.notes)
  }
}

extension Account: RepoStorable {}
