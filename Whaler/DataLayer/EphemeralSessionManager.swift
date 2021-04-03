//
//  EphemeralSessionManager.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/2/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

protocol EphemeralObject: IdProviding {}

class EphemeralSessionManager {
  private var ephemeralSessions = [String: AnyObject]()
  
  func register(_ object: EphemeralObject) {
    ephemeralSessions[object.id] = object as AnyObject
  }
  
  func unregister(_ object: EphemeralObject) {
    ephemeralSessions.removeValue(forKey: object.id)
  }
}
