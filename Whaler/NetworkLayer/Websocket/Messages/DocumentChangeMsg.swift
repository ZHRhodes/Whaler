//
//  DocumentChangeMsg.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/26/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

enum SocketMsg {
  case docChange(DocumentChange),
       resourceConnection(ResourceConnection),
       resourceConnectionConf(ResourceConnectionConf)
}

struct SocketMessage<T: Codable>: Codable {
  var type: SocketMessageType
  var data: T
}

//struct SocketMessage: SocketMessageT, Codable {
//  var type: SocketMessageType = .docChange
//  var data: Data
//
//  var msg: SocketMsg {
//    switch type {
//    case .docChange:
//      let docChange = try! JSONDecoder().decode(DocumentChange.self, from: data)
//      return .docChange(docChange)
//    case .resourceConnection:
//      fatalError()
//    default:
//      fatalError()
//    }
//  }
//
////  func data() -> SocketData {
////    return docChange
////  }
//
////  init(docChange: DocumentChange) {
////    self.docChange = docChange
////  }
//
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    type = try container.decode(SocketMessageType.self, forKey: .type)
//    data = try container.decode(Data.self, forKey: .data)
//  }
//
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encode(type, forKey: .type)
//    try container.encode(data, forKey: .data)
//  }
//
//  enum CodingKeys: String, CodingKey {
//    case type, data
//  }
//}

struct DocumentChange: SocketData {
  let type: DocumentChangeType
  let value: String
  let range: Range<Int>
}

enum DocumentChangeType: String, Codable {
  case insert = "INS",
       format = "FMT",
       delete = "DEL"
}
