//
//  SFNetworkInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/6/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct SFNetworkInterface { //fix up conformance later}: NetworkInterface {
  static private let tokenContainer: TokenContainer.Type = SFSession.self
  static private let networker: Networker.Type = JustNetworker.self
  static private let baseDataPath = "https://na111.salesforce.com/services/data/v37.0"

  static func post<B, R>(path: String, jsonBody: B?) -> Response<R> where B : Encodable, R : Decodable, R : Encodable {
    fatalError("not implemented")
  }
  
  static func post<R>(path: String, formBody: [String : String]) -> Response<R> where R : Decodable, R : Encodable {
    fatalError("not implemented")
  }
  
  static func get(path: String, params: [String : String]) throws -> NetworkResult {
    guard let accessToken = SFNetworkInterface.tokenContainer.accessToken else { throw SFError.emptyAccessToken }
    let request = NetworkRequest(method: .get,
                                 path: baseDataPath + path,
                                 headers: ["Authorization": "Bearer \(accessToken)"],
                                 params: params,
                                 jsonBody: nil)
    return execute(request: request)
  }
  
  private static func execute(request: NetworkRequest) -> NetworkResult {
    //Warning: endless loop potential in this function via recursion
    var result = networker.execute(request: request)

    if result.statusCode == 403 {
      do {
        try refreshAccessToken()
        result = networker.execute(request: request)
      } catch {
        return NetworkResult(ok: false, statusCode: nil, data: "Failed to refresh SF access token.".data(using: .utf8))
      }
    }
    
    return result
  }
  
  static func refreshAccessToken() throws {
    let clientId = "3MVG9Kip4IKAZQEVUyT0t2bh34B.GSy._2rVDX_MVJ7a3GyUtHsAGG2GZU843.Gajp7AusaDdCEero1UuAJwK"
    let clientSecret = "44AD56EB0DEA62F7001FA2E05EE5C83018781D89EA78D52E9677619E194937E8"
    guard let refreshToken = tokenContainer.refreshToken else { throw SFError.emptyRefreshToken }
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
    let result = networker.execute(request: request)
    guard let data = result.data else {
      throw SFError.failedToRefreshAccessToken
    }
    
    do {
      let resultAsResponse = try JSONDecoder().decode(SF.NewAccessToken.self, from: data)
      guard let newAccessToken = resultAsResponse.access_token else {
        tokenContainer.accessToken = ""
        throw SFError.failedToRefreshAccessToken
      }
      tokenContainer.accessToken = newAccessToken
    } catch let error {
      Log.error("Failed to refresh SF access token. Error: \(error)", context: .salesforce)
      throw error
    }
  }
}
