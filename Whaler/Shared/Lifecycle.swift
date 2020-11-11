//
//  Lifecycle.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/8/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

protocol TokenContainer {
  static var accessToken: String? { get set }
  static var refreshToken: String? { get set }
}

enum Lifecycle: TokenContainer {
  static var currentUser: User? {
    willSet {
      Log.info("Current user: \(newValue as Any)")
      if let newValue = newValue, newValue != currentUser {
        do {
          let currentUserData = try JSONEncoder().encode(newValue)
          Keychain.save(key: .currentUser, data: currentUserData)
        } catch let error {
          Log.error("Failed to save currentUserData to keychain. Error: \(error)", context: .lifecycle)
        }
      } else if newValue == nil {
        Keychain.delete(key: .currentUser)
      }
    }
  }
  
  static var accessToken: String? {
    willSet {
      if let newValue = newValue, newValue != accessToken, let data = newValue.data(using: .utf8) {
        Keychain.save(key: .apiAccessToken, data: data)
      } else if newValue == nil {
        Keychain.delete(key: .apiAccessToken)
      }
    }
  }
  
  static var refreshToken: String? {
    willSet {
      if let newValue = newValue, newValue != refreshToken, let data = newValue.data(using: .utf8) {
        Keychain.save(key: .apiRefreshToken, data: data)
      } else if newValue == nil {
        Keychain.delete(key: .apiRefreshToken)
      }
    }
  }
  
  static func loadApiTokens() {
    if let accessTokenData = Keychain.load(key: .apiAccessToken) {
      accessToken = String(data: accessTokenData, encoding: .utf8)
    }
    
    if let refreshTokenData = Keychain.load(key: .apiRefreshToken) {
      refreshToken = String(data: refreshTokenData, encoding: .utf8)
    }
  }
  
  static func hasTokens() -> Bool {
    return accessToken != nil && refreshToken != nil
  }
  
  static func refreshAPITokens(using interface: APIInterface = APINetworkInterface(), completion: @escaping BoolClosure) {
    let success = interface.refreshTokens()
    completion(success)
  }
  
  static func logOut(using interface: APIInterface = APINetworkInterface(), tokenContainers: [TokenContainer.Type] = [Lifecycle.self, SFSession.self]) {
    interface.logOut()
    for containerType in tokenContainers {
      containerType.accessToken = nil
      containerType.refreshToken = nil
    }
    NotificationCenter.default.post(name: .unauthorizedUser, object: nil)
  }
  
  static func loadCurrentUser() {
    if let userData = Keychain.load(key: .currentUser) {
      do {
        currentUser = try JSONDecoder().decode(User.self, from: userData)
      } catch let error {
        Log.error("failed to decode currentUserData from Keychain. Error: \(error)", context: .lifecycle)
      }
    }
  }
}
