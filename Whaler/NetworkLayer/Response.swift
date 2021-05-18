//
//  Response.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/7/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct Response<T: Codable>: Codable {
  enum Result {
    case error(Int, String)
    case value(ResponseData<T>)
  }
  
  private var code: Int
  private var message: String
  private var hasError: Bool
  private var data: ResponseData<T>?
  
  var result: Result {
    guard !hasError else { return .error(code, message) }
    guard let data = data else { return .error(4000, "No response data") }
    return .value(data)
  }
  
  init(_ error: ResponseError) {
    self.code = error.code
    self.message = error.message
    self.hasError = error.hasError
  }
  
  init(code: Int, message: String) {
    self.code = code
    self.message = message
    self.hasError = true
  }
}

struct ResponseData<T: Codable>: Codable {
  let tokens: Tokens?
  let response: T
}

enum ResponseError {
  case failedToDecodeResultData
  case accessTokenIssue
  
  var code: Int {
    switch self {
    case .failedToDecodeResultData:
      return -1
    case .accessTokenIssue:
      return -2
    }
  }
  
  var message: String {
    switch self {
    case .failedToDecodeResultData:
      return "Local error: failed to decode the result data as a Response"
    case .accessTokenIssue:
      return "Local error: invalid or missing access token"
    }
  }
  
  var hasError: Bool {
    return true
  }
}

