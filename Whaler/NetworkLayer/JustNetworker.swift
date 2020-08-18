//
//  JustNetworker.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/16/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Combine
import Just

struct JustNetworker: Networker {
  static func execute<T: Encodable>(request: NetworkRequest<T>) -> NetworkResult {
    switch request.method {
    case .get:
      return JustNetworker.get(url: request.path, params: request.params, headers: request.headers)
    case .post:
      return JustNetworker.post(url: request.path, headers: request.headers, body: request.body)
    }
  }
  
  static private func post<T: Encodable>(url: String, headers: [String: String], body: T?) -> NetworkResult {
    let result: HTTPResult = Just.post(url, json: body, headers: headers)
    return NetworkResult(ok: result.ok, statusCode: result.statusCode, data: result.content)
  }
  
  static private func get(url: String, params: [String : String], headers: [String: String]) -> NetworkResult {
    let result = Just.get(url, params: params, headers: headers)
    return NetworkResult(ok: result.ok, statusCode: result.statusCode, data: result.content)
  }
}
