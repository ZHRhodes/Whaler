//
//  SFAccount.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

extension SF {
  struct Account: Codable {
    var Id: String?
    var Name: String?
    var `Type`: String?
    var OwnerId: String?
    var Industry: String?
    var AnnualRevenue: Int?
    var BillingCity: String?
    var BillingState: String?
    var Phone: String?
    var Website: String?
    var NumberOfEmployees: Int?
    var Description: String?
  }
}
