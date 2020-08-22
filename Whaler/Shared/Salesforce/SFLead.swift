//
//  SFLead.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/21/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

extension SF {
  struct Lead: Codable {
    var Id: String?
    var Company: String?
    var FirstName: String?
    var LastName: String?
    var Title: String?
    var Phone: String?
    var Email: String?
    
    var accountId: String?
    
    private enum CodingKeys: String, CodingKey {
      case Id, Company, FirstName, LastName, Title, Phone, Email
    }
  }
}
