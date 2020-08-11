//
//  Keychain.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/6/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Security

class Keychain {
  enum Key {
    case accessToken, refreshToken
  }
  
  @discardableResult
  class func save(key: Key, data: Data) -> OSStatus {
    let query: [String : Any] = [
      kSecClass as String       : kSecClassGenericPassword as String,
      kSecAttrAccount as String : key,
      kSecValueData as String   : data
    ]

    SecItemDelete(query as CFDictionary)
    return SecItemAdd(query as CFDictionary, nil)
  }

  class func load(key: Key) -> Data? {
    let query: [String : Any] = [
      kSecClass as String       : kSecClassGenericPassword,
      kSecAttrAccount as String : key,
      kSecReturnData as String  : kCFBooleanTrue!,
      kSecMatchLimit as String  : kSecMatchLimitOne
    ]

    var dataTypeRef: AnyObject? = nil
    let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    if status == noErr,
       let data = dataTypeRef as! Data? {
        return data
    } else {
        return nil
    }
  }

  class func createUniqueID() -> String {
      let uuid: CFUUID = CFUUIDCreate(nil)
      let cfStr: CFString = CFUUIDCreateString(nil, uuid)

      let swiftString: String = cfStr as String
      return swiftString
  }
}
