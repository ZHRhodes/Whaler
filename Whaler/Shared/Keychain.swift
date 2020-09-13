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
  enum Key: String {
    case apiAccessToken, apiRefreshToken, sfAccessToken, sfRefreshToken
  }
  
  @discardableResult
  class func save(key: Key, data: Data) -> OSStatus {
    let attributes: [String : Any] = [
      kSecClass as String       : kSecClassGenericPassword,
      kSecAttrAccount as String : key.rawValue,
      kSecValueData as String   : data
    ]

    var status = update(key: key, data: data)
    if status == errSecSuccess {
      return status
    } else {
      status = SecItemAdd(attributes as CFDictionary, nil)
      return status
    }
  }
  
  class func update(key: Key, data: Data) -> OSStatus {
    let query: [String: Any] = [
      kSecClass as String       : kSecClassGenericPassword,
      kSecAttrAccount as String : key.rawValue
    ]
    
    let attributes: [String: Any] = [
      kSecValueData as String   : data
    ]
    
    return SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
  }

  class func load(key: Key) -> Data? {
    let query: [String : Any] = [
      kSecClass as String       : kSecClassGenericPassword,
      kSecAttrAccount as String : key.rawValue,
      kSecReturnData as String  : true,
      kSecMatchLimit as String  : kSecMatchLimitOne,
      kSecReturnAttributes as String: true
    ]

    var dataTypeRef: CFTypeRef?
    let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    
    guard status == errSecSuccess else {
      print("failed to load key: \(key). Status: \(status)")
      //log this
      return nil
    }
    
    guard let existingItem = dataTypeRef as? [String: Any],
          let data = existingItem[kSecValueData as String] as? Data else {
      print("failed to extract data from existingItem with key: \(key)")
      //log this
      return nil
    }
    
    return data
  }

  class func createUniqueID() -> String {
      let uuid: CFUUID = CFUUIDCreate(nil)
      let cfStr: CFString = CFUUIDCreateString(nil, uuid)

      let swiftString: String = cfStr as String
      return swiftString
  }
}
