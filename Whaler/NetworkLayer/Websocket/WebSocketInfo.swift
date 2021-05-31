//
//  WebSocketInfo.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/13/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

class WebSocketInfo {
  let id: String
  var delegates: WebSocketDelegates = WebSocketDelegates()
  
  init(id: String) {
    self.id = id
  }
}

class WebSocketDelegates {
  var delegates = NSPointerArray.weakObjects()
  
  var all: [LiteWebSocketDelegate] {
    return delegates.allObjects as? [LiteWebSocketDelegate] ?? []
  }

  func add(delegate: LiteWebSocketDelegate?) {
    guard let delegate = delegate else { return }
    delegates.addObject(delegate)
  }
}
