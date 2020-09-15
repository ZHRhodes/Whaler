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

final class Account: NSObject, Codable {
  private enum CodingKeys: String, CodingKey {
    case id, owner, name, industry, employees, annualRevenue, billingCity, billingState, phone, website, type, accountDescription, state, contactGrouper, notes
  }
  
  let id: String
  let owner: String
  let name: String
  let industry: String?
  let employees: String?
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
  
  var state: WorkState
  
  var contactGrouper = Grouper<WorkState, Contact>(groups: WorkState.allCases)
  
  var notes: String
  
  override init() {
    id = ""
    owner = ""
    name = ""
    industry = ""
    employees = ""
    annualRevenue = ""
    billingCity = ""
    billingState = ""
    phone = ""
    website = ""
    type = ""
    accountDescription = ""
    state = .inProgress
    notes = ""
    super.init()
  }
  
  init(id: String, owner: String, name: String, industry: String?, employees: String?, annualRevenue: String?, billingCity: String?, billingState: String?, phone: String?, website: String?, type: String?, accountDescription: String?, state: WorkState, contactGrouper: Grouper<WorkState, Contact>? = nil, notes: String = "") {
    self.id = id
    self.owner = owner
    self.name = name
    self.industry = industry
    self.employees = employees
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
    id = dictionary["Account ID"] ?? ""
    owner = dictionary["Account Owner"] ?? ""
    name = dictionary["Account Name"] ?? ""
    industry = dictionary["Industry"]
    employees = dictionary["Employees"]
    annualRevenue = dictionary["Annual Revenue"]
    billingCity = dictionary["Billing City"]
    billingState = dictionary["Billing State/Province"]
    phone = dictionary["Account: Phone"]
    website = dictionary["Website"]
    type = dictionary["Type"]
    accountDescription = dictionary["Account Description"]
    state = .ready
    notes = ""
  }
  
  init(sfAccount: SF.Account) {
    id = sfAccount.Id ?? ""
    owner = sfAccount.OwnerId ?? ""
    name = sfAccount.Name ?? ""
    industry = sfAccount.Industry
    employees = String(sfAccount.NumberOfEmployees ?? 0)
    annualRevenue = String(sfAccount.AnnualRevenue ?? 0)
    billingCity = sfAccount.BillingCity
    billingState = sfAccount.BillingState
    phone = sfAccount.Phone
    website = sfAccount.Website
    type = sfAccount.Type
    accountDescription = sfAccount.Description
    state = .ready
    notes = ""
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
    let owner = managedObject.value(forKey: CodingKeys.owner.rawValue) as? String ?? ""
    let name = managedObject.value(forKey: CodingKeys.name.rawValue) as? String ?? ""
    let industry = managedObject.value(forKey: CodingKeys.industry.rawValue) as? String
    let employees = managedObject.value(forKey: CodingKeys.employees.rawValue) as? String
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
    self.init(id: id, owner: owner, name: name, industry: industry, employees: employees, annualRevenue: annualRevenue, billingCity: billingCity, billingState: billingState, phone: phone, website: website, type: type, accountDescription: accountDescription, state: state, notes: notes)
  }
  
  func setProperties(in managedObject: NSManagedObject) {
    managedObject.setValue(id, forKey: CodingKeys.id.rawValue)
    managedObject.setValue(owner, forKey: CodingKeys.owner.rawValue)
    managedObject.setValue(name, forKey: CodingKeys.name.rawValue)
    managedObject.setValue(industry, forKey: CodingKeys.industry.rawValue)
    managedObject.setValue(employees, forKey: CodingKeys.employees.rawValue)
    managedObject.setValue(annualRevenue, forKey: CodingKeys.annualRevenue.rawValue)
    managedObject.setValue(billingCity, forKey: CodingKeys.billingCity.rawValue)
    managedObject.setValue(billingState, forKey: CodingKeys.billingState.rawValue)
    managedObject.setValue(phone, forKey: CodingKeys.phone.rawValue)
    managedObject.setValue(website, forKey: CodingKeys.website.rawValue)
    managedObject.setValue(type, forKey: CodingKeys.type.rawValue)
    managedObject.setValue(accountDescription, forKey: CodingKeys.accountDescription.rawValue)
    managedObject.setValue(state.rawValue, forKey: CodingKeys.state.rawValue)
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
