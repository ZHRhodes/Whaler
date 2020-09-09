//
//  Lifecycle.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/8/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

enum Lifecycle {
  static func hasTokens(using interface: APIInterface.Type = APINetworkInterface.self) -> Bool {
    return interface.hasTokens
  }
  
  static func refreshAPITokens(using interface: APIInterface = APINetworkInterface(), completion: @escaping BoolClosure) {
    let success = interface.refreshTokens()
    completion(success)
  }
  
  static func logOut(using interface: APIInterface = APINetworkInterface()) {
    interface.logOut()
    NotificationCenter.default.post(name: .unauthorizedUser, object: nil)
  }
}
