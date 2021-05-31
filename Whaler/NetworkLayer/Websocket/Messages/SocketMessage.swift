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
  case resourceUpdated = "resourceUpdated"
}

protocol SocketData: Codable {}

enum SocketMsg {
  case docChange(DocumentChange),
       docChangeReturn(DocumentChangeReturn, wasSender: Bool),
       resourceConnection(ResourceConnection),
       resourceConnectionConf(ResourceConnectionConf),
       resourceUpdated(ResourceUpdated)
}

struct SocketMessage<T: Codable>: Codable {
  var messageId: String = ""
  var type: SocketMessageType
  var data: T
  
  init(type: SocketMessageType, data: T) {
    self.type = type
    self.data = data
  }
}
