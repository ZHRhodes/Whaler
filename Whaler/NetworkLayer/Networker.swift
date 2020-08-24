//
//  Networker.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/16/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Combine

enum HTTPRequestMethod {
  case get, post
}

protocol Networker {
  static func execute(request: NetworkRequest) -> NetworkResult
}

struct NetworkResult {
  let ok: Bool
  let statusCode: Int?
  let data: Data?
}

typealias NetworkResultPublisher = Just<NetworkResult>

struct NetworkRequest {
  let method: HTTPRequestMethod
  var path: String
  let headers: [String: String]
  let params: [String: String]
  let formBody: [String: String]
  let jsonBody: Any?
  
  init(method: HTTPRequestMethod,
       path: String,
       headers: [String: String],
       params: [String: String],
       jsonBody: Any?) {
    self.method = method
    self.path = path
    self.headers = headers
    self.params = params
    self.formBody = [:]
    self.jsonBody = jsonBody
  }
  
  init(method: HTTPRequestMethod,
       path: String,
       headers: [String: String],
       params: [String: String],
       formBody: [String: String] = [:]) {
    self.method = method
    self.path = path
    self.headers = headers
    self.params = params
    self.formBody = formBody
    self.jsonBody = nil
  }
}

