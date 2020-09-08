//
//  Salesforce.swift
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
  //TODO: Make secure
  @UserDefaultsManaged(key: "sfAccessToken")
  static var accessToken: String?
  
  //TODO: Make secure
  @UserDefaultsManaged(key: "sfRefreshToken")
  static var refreshToken: String?
  
  static private let networker: Networker.Type = JustNetworker.self
  
  static func query<T: Codable>(_ soql: String) throws -> [T] {
    guard let accessToken = SF.accessToken else { throw SFError.emptyAccessToken }
    let request = NetworkRequest(method: .get,
                                 path: "services/data/v37.0/query",
                                 headers: ["Authorization": "Bearer \(accessToken)"],
                                 params: ["q": soql],
                                 jsonBody: nil)
    let result = SF.networker.execute(request: request)
    guard let data = result.data else { return [] }
    let resultAsResponse: SF.QueryResponse<T>
    
    do {
      resultAsResponse = try JSONDecoder().decode(QueryResponse<T>.self, from: data)
    } catch let error {
      print(error)
      throw error
    }
    
    return resultAsResponse.records ?? [T]()
  }
  
  static func refreshAccessToken() throws {
    let clientId = "3MVG9Kip4IKAZQEVUyT0t2bh34B.GSy._2rVDX_MVJ7a3GyUtHsAGG2GZU843.Gajp7AusaDdCEero1UuAJwK"
    let clientSecret = "44AD56EB0DEA62F7001FA2E05EE5C83018781D89EA78D52E9677619E194937E8"
    guard let refreshToken = SF.refreshToken else { throw SFError.emptyRefreshToken }
    let body = [
      "grant_type": "refresh_token",
      "client_id": clientId,
      "client_secret": clientSecret,
      "refresh_token": refreshToken
    ]
    let request = NetworkRequest(method: .post,
                                 path: "https://na111.salesforce.com/services/oauth2/token",
                                 headers: [:],
                                 params: [:],
                                 formBody: body)
    let result = SF.networker.execute(request: request)
    guard let data = result.data else {
      throw SFError.failedToRefreshAccessToken
    }
    
    do {
      let resultAsResponse = try JSONDecoder().decode(SF.NewAccessToken.self, from: data)
      guard let newAccessToken = resultAsResponse.access_token else {
        SF.accessToken = ""
        throw SFError.failedToRefreshAccessToken
      }
      SF.accessToken = newAccessToken
    } catch let error {
      print(error)
      throw error
    }
  }
}
