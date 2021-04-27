//
//  WebSocketConn.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/13/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Starscream

extension WebSocketClient {
  func send<T: Codable>(message: SocketMessage<T>) {
    do {
      let data = try JSONEncoder().encode(message)
      write(data: data)
    } catch {
      Log.warning("Failed to send message:\n\(message)")
    }
  }
}
