//
//  LiteWebSocketDelegate.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/13/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Starscream

protocol LiteWebSocketDelegate: AnyObject {
  func didReceiveMessage(_ message: SocketMsg, socket: WebSocketClient)
  func connectionEstablished(socket: WebSocketClient)
}
