//
//  AuthenticationInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/7/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct AuthenticationInteractor {
  let networkInterface: NetworkInterface
  
  func signIn(email: String, password: String, success: @escaping VoidClosure, failure: @escaping VoidClosure) {
    let body = ["email": email, "password": password]
    let response: Response<User> = networkInterface.post(path: "https://getwhalergo.herokuapp.com/api/user/login",
                                         jsonBody: body)
    switch response.result {
    case .error(let code, let message):
      Log.debug("Failed to sign in. code: \(code), message: \(message)")
      failure()
    case .value(let userResponse):
      Lifecycle.currentUser = userResponse.response
      success()
    }
  }
}
