//
//  SFContact.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/21/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

extension SF {
  struct Contact: Codable {
    var Id: String?
    var AccountId: String?
    var FirstName: String?
    var LastName: String?
    var Title: String?
    var Phone: String?
    var Email: String?
  }
}

