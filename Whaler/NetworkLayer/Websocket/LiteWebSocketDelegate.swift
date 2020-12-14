//
//  LiteWebSocketDelegate.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/13/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

protocol LiteWebSocketDelegate: class {
  func didReceiveMessage(_ message: SocketMessage)
}
