//
//  SFGroupModels.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/30/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

extension SF {
  struct IndustryGroup: Codable {
    var Industry: String?
  }
  
  struct OwnerNameGroup: Codable {
    var Name: String?
  }
  
  struct BillingStateGroup: Codable {
    var BillingState: String?
  }
}
