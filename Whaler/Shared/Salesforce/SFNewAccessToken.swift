//
//  SFNewAccessToken.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/23/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

extension SF {
  struct NewAccessToken: Codable {
    var id: String?
    var issued_at: String?
    var instance_url: String?
    var signature: String?
    var access_token: String?
    var token_type: String?
    var scope: String?
  }
}
