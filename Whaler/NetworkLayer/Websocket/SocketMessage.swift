//
//  SocketMessage.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/13/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

enum SocketMessageType: String, Codable {
  case docDelta = "docDelta"
}

struct SocketMessage: Codable {
  let type: SocketMessageType
  let data: DocumentDelta
}

struct DocumentDelta: Codable {
  let value: String
}
