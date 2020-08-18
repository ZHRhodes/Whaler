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
  static func execute<T: Encodable>(request: NetworkRequest<T>) -> NetworkResult
}

struct NetworkResult {
  let ok: Bool
  let statusCode: Int?
  let data: Data?
}

typealias NetworkResultPublisher = Just<NetworkResult>

struct NetworkRequest<T: Encodable> {
  let method: HTTPRequestMethod
  var path: String
  let headers: [String: String]
  let params: [String: String]
  let body: T?
  
  init(method: HTTPRequestMethod,
       path: String,
       headers: [String: String],
       params: [String: String],
       body: T?) {
    self.method = method
    self.path = path
    self.headers = headers
    self.params = params
    self.body = body
  }
}

