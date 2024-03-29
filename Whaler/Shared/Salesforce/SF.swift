//
//  SF.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/7/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

enum SFError: Error {
  case failedToRefreshAccessToken, emptyRefreshToken, emptyAccessToken
}

class SF {
  static private let networkInterface = SFNetworkInterface.self
  
  static func query<T: Codable>(_ soql: Soql) throws -> [T] {
    let result: NetworkResult
    do {
      result = try networkInterface.get(path: "/query", params: ["q": soql])
    } catch {
      Log.error(error.localizedDescription, context: .salesforce)
      throw error
    }
    
    guard let data = result.data else { return [] }
    let resultAsResponse: SF.QueryResponse<T>
    
    do {
      resultAsResponse = try JSONDecoder().decode(QueryResponse<T>.self, from: data)
    } catch let error {
      Log.error(error.localizedDescription, context: .salesforce)
      throw error
    }
    
    return resultAsResponse.records ?? [T]()
  }
  
  static func refreshAccessToken() throws {
    try networkInterface.refreshAccessToken()
  }
}
