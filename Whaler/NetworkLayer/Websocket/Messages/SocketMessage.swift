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
  case docChangeReturn = "docChangeReturnOps"
  case resourceConnection = "resourceConnection"
  case resourceConnectionConf = "resourceConnectionConf"
}

protocol SocketData: Codable {}

protocol SocketMessageT {
  var type: SocketMessageType { get }
//  var data: Data { get }
}

private enum SocketMessageCodingKeys: String, CodingKey {
  case type, data
}

//extension SocketMessage {
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: SocketMessageCodingKeys.self)
//    let type = try container.decode(SocketMessageType.self, forKey: .type)
//    let docChange = try container.decode(DocumentChange.self, forKey: .data)
//  }
//
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: SocketMessageCodingKeys.self)
//    try container.encode(type, forKey: .type)
//    try container.encode(data(), forKey: .data)
//  }
//}


//struct SocketMessage: SocketMessageT, Codable {
//  let type: SocketMessageType
//  let data: SocketData
//}


