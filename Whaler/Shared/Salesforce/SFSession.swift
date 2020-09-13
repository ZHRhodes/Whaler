//
//  SFSession.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/12/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

class SFSession: TokenContainer {
  static var accessToken: String? {
    willSet {
      if let newValue = newValue, newValue != accessToken, let data = newValue.data(using: .utf8) {
        Keychain.save(key: .sfAccessToken, data: data)
      } else if newValue == nil {
        Keychain.delete(key: .sfAccessToken)
      }
    }
  }
  
  static var refreshToken: String? {
    willSet {
      if let newValue = newValue, newValue != refreshToken, let data = newValue.data(using: .utf8) {
        Keychain.save(key: .sfRefreshToken, data: data)
      } else if newValue == nil {
        Keychain.delete(key: .sfRefreshToken)
      }
    }
  }
  
  static func loadSFTokens() {
    if let accessTokenData = Keychain.load(key: .sfAccessToken) {
      accessToken = String(data: accessTokenData, encoding: .utf8)
    }
    
    if let refreshTokenData = Keychain.load(key: .sfRefreshToken) {
      refreshToken = String(data: refreshTokenData, encoding: .utf8)
    }
  }
  
  static func hasTokens() -> Bool {
    return accessToken != nil && refreshToken != nil
  }
}
