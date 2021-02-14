//
//  RepoError.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/12/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

struct RepoError: Error {
  var reason: String
  var humanReadableMessage: String?
  
  init(reason: String, humanReadableMessage: String?) {
    self.reason = reason
    self.humanReadableMessage = humanReadableMessage
  }
}
