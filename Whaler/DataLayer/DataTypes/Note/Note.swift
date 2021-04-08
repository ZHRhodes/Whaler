//
//  Note.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

class Note: Codable {
  let id: String
  let accountId: String
  var content: String
  
  init(id: String, accountId: String, content: String) {
    self.id = id
    self.accountId = accountId
    self.content = content
  }
}

extension Note: RepoStorable{}
