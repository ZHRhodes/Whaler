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
  static func execute(request: NetworkRequest) -> NetworkResult {
    switch request.method {
    case .get:
      return JustNetworker.get(url: request.path, params: request.params, headers: request.headers)
    case .post:
      return JustNetworker.post(url: request.path, headers: request.headers, formBody: request.formBody, jsonBody: request.jsonBody)
    }
  }
  
  static private func post(url: String, headers: [String: String], formBody: [String: String], jsonBody: Any?) -> NetworkResult {
    let result: HTTPResult = Just.post(url, data: formBody, json: jsonBody, headers: headers)
    return NetworkResult(ok: result.ok, statusCode: result.statusCode, data: result.content)
  }
  
  static private func get(url: String, params: [String : String], headers: [String: String]) -> NetworkResult {
    let result = Just.get(url, params: params, headers: headers)
    return NetworkResult(ok: result.ok, statusCode: result.statusCode, data: result.content)
  }
}
