//
//  CustomError.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/10/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

class CustomError: LocalizedError {
  let message: String

  init(_ message: String) {
    self.message = message
  }
  
  var errorDescription: String? {
    return message
  }
}
