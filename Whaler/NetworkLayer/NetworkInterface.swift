//
//  NetworkInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/16/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
//
protocol NetworkInterface {
  func post<B: Encodable, R: Codable>(path: String, jsonBody: B?) -> Response<R>
  func post<R: Codable>(path: String, formBody: [String: String]) -> Response<R>
  func get<R: Codable>(path: String, params: [String : String]) -> Response<R>
}

protocol APIInterface {
  func logOut() -> Response<EmptyRemote>
  func refreshTokens() -> Bool
}

struct APINetworkInterface: NetworkInterface {
  //Temp
  @UserDefaultsManaged(key: "accessToken")
  static var accessToken: String?
  
  //Temp
  @UserDefaultsManaged(key: "refreshToken")
  static private var refreshToken: String?
  
  private let networker: Networker.Type = JustNetworker.self

  private var authorizationHeader: [String: String] {
    return ["Authorization": APINetworkInterface.accessToken ?? ""]
  }

  func post<B: Encodable, R: Codable>(path: String, jsonBody: B? = nil) -> Response<R> {
    let request = NetworkRequest(method: .post,
                                 path: path,
                                 headers: authorizationHeader,
                                 params: [:],
                                 jsonBody: jsonBody)
    return execute(request: request)
  }
  
  func post<R: Codable>(path: String, formBody: [String : String]) -> Response<R> {
    let request = NetworkRequest(method: .post,
                                 path: path,
                                 headers: authorizationHeader,
                                 params: [:],
                                 formBody: formBody)
    return execute(request: request)
  }

  func get<R: Codable>(path: String, params: [String : String]) -> Response<R> {
    let request = NetworkRequest(method: .get,
                                 path: path,
                                 headers: authorizationHeader,
                                 params: params,
                                 jsonBody: nil)
    return execute(request: request)
  }

  private func execute<R: Codable>(request: NetworkRequest) -> Response<R> {
    var result = networker.execute(request: request)

    if result.statusCode == 403 {
//      refreshTokens()
      result = networker.execute(request: request)
    }

    if result.statusCode == 401 {
//      NotificationCenter.default.post(name: .unauthorizedUser, object: nil)
    }

    if !result.ok {
//      log.warning("Request \(request.path) failed with status code \(String(describing: result.statusCode))", context: LoggingContext.rest)
      return Response<R>(code: result.statusCode ?? -1, message: "")
    }

    guard let data = result.data,
      let response = try? JSONDecoder().decode(Response<R>.self, from: data) else {
      //couldn't decode the response in the way we expected, log it
//        log.error("Failed to decode response from \(request.path)", context: LoggingContext.rest)
        return Response<R>(.failedToDecodeResultData)
    }
    switch response.result {
    case .error(let code, let message):
//      log.error("Error from request path \(request.path) -- Code: \(code), Message: \(message)", context: LoggingContext.rest)
      if code == 4004 {
//        NotificationCenter.default.post(name: .unauthorizedUser, object: nil)
      }
    case .value(let rResponse):
      if let accessToken = rResponse.tokens?.accessToken, !accessToken.isEmpty {
        APINetworkInterface.accessToken = accessToken
      }

      if let refreshToken = rResponse.tokens?.refreshToken, !refreshToken.isEmpty {
        APINetworkInterface.refreshToken = refreshToken
      }
    }

    return response
  }
  
  private struct AnyCodable: Codable {}
}

extension APINetworkInterface: APIInterface {
  @discardableResult
  func logOut() -> Response<EmptyRemote> {
    let body = [String: String]()
    let response: Response<EmptyRemote> = post(path: "/api/user/logout", formBody: body)
    return response
  }

  @discardableResult
  func refreshTokens() -> Bool {
    guard let refreshToken = APINetworkInterface.refreshToken else { return false }
    let refreshRequest = NetworkRequest(method: .post,
                                        path: "/api/user/refresh",
                                        headers: authorizationHeader,
                                        params: [:],
                                        formBody: ["refreshToken": refreshToken])
    let result = networker.execute(request: refreshRequest)

    guard let data = result.data,
      let response = try? JSONDecoder().decode(Response<AnyCodable?>.self, from: data) else {
        //log and do something
        return false
    }

    switch response.result {
    case .error(let code, let message):
//      log.error("Error from request path /api/user/refresh -- Code: \(code), Message: \(message)", context: LoggingContext.rest)
      return false
    case .value(let tokensResponse):
      guard let accessToken = tokensResponse.tokens?.accessToken,
        let refreshToken = tokensResponse.tokens?.refreshToken else {
          return false
      }
      APINetworkInterface.accessToken = accessToken
      APINetworkInterface.refreshToken = refreshToken
      return true
    }
  }
}

struct EmptyRemote: Codable {}
