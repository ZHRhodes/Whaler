//
//  Account.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import MobileCoreServices

final class Account: NSObject, Codable {
  let id: String
  let owner: String
  let name: String
  let industry: String?
  let employees: String?
  let annualRevenue: String?
  let billingCity: String?
  let billingState: String?
  let contactsCount: String?
  let phone: String?
  let website: String?
  let type: String?
  let accountDescription: String?
  
  var state: WorkState
  
  init(dictionary: Dictionary<String, String>) {
    id = dictionary["Account ID"] ?? ""
    owner = dictionary["Account Owner"] ?? ""
    name = dictionary["Account Name"] ?? ""
    industry = dictionary["Industry"]
    employees = dictionary["Employees"]
    annualRevenue = dictionary["Annual Revenue"]
    billingCity = dictionary["Billing City"]
    billingState = dictionary["Billing State/Province"]
    contactsCount = String(Int.random(in: Range(uncheckedBounds: (5, 25))))
    phone = dictionary["Phone"]
    website = dictionary["Website"]
    type = dictionary["Type"]
    accountDescription = dictionary["Description"]
    state = WorkState.allCases.randomElement()!
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
