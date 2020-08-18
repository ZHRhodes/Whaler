//
//  UserDefaultsManaged.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/16/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultsManaged<T> {
  let key: String
  var storage: UserDefaults = .standard
  
  var wrappedValue: T? {
    get { return storage.object(forKey: key) as? T }
    set { storage.set(newValue, forKey: key) }
  }
}
