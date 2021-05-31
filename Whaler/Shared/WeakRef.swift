//
//  WeakRef.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/31/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

class WeakRef<T> where T: AnyObject {
  private(set) weak var value: T?

  init(value: T?) {
      self.value = value
  }
}
