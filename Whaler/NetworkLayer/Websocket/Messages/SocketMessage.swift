//
//  SocketMessage.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/13/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

enum SocketMessageType: String, Codable {
  case docChange = "docChange"
}

struct SocketMessage: Codable {
  let type: SocketMessageType
  let data: DocumentChange
}

struct DocumentChange: Codable {
  let type: DocumentChangeType
  let value: String
  let range: Range<Int>
}

enum DocumentChangeType: String, Codable {
  case insert = "INS",
       format = "FMT",
       delete = "DEL"
}
