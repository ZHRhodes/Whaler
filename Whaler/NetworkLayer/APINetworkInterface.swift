//
//  APINetworkInterface.swift
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
  @discardableResult func logOut() -> Response<EmptyRemote>
  @discardableResult func refreshTokens() -> Bool
}

struct APINetworkInterface: NetworkInterface {
  private let networker: Networker.Type = JustNetworker.self
  private let tokenContainer: TokenContainer.Type = Lifecycle.self

  private var authorizationHeader: [String: String] {
    return ["Authorization": tokenContainer.accessToken ?? ""]
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

    //Potential for endless loop
    if result.statusCode == 403 {
      refreshTokens()
      result = networker.execute(request: request)
    }

    if result.statusCode == 401 {
      NotificationCenter.default.post(name: .unauthorizedUser, object: nil)
    }

    if !result.ok {
//      log.warning("Request \(request.path) failed with status code \(String(describing: result.statusCode))", context: LoggingContext.rest)
      return Response<R>(code: result.statusCode ?? -1, message: "")
    }

    guard let data = result.data else { return Response<R>(.failedToDecodeResultData) }
    let response: Response<R>
    do {
      response = try JSONDecoder().decode(Response<R>.self, from: data)
    } catch let error {
//      log.error("Failed to decode response from \(request.path)", context: LoggingContext.rest)
      print(error)
      return Response<R>(.failedToDecodeResultData)
    }
    switch response.result {
    case .error(let code, let message):
//      log.error("Error from request path \(request.path) -- Code: \(code), Message: \(message)", context: LoggingContext.rest)
      if code == 4004 {
        NotificationCenter.default.post(name: .unauthorizedUser, object: nil)
      }
    case .value(let rResponse):
      if let accessToken = rResponse.tokens?.accessToken, !accessToken.isEmpty {
        tokenContainer.accessToken = accessToken
      }

      if let refreshToken = rResponse.tokens?.refreshToken, !refreshToken.isEmpty {
        tokenContainer.refreshToken = refreshToken
      }
    }

    return response
  }
}

extension APINetworkInterface: APIInterface {  
  @discardableResult
  func logOut() -> Response<EmptyRemote> {
    let body = [String: String]()
    let response: Response<EmptyRemote> = post(path: "https://getwhalergo.herokuapp.com/api/user/logout",
                                               formBody: body)
    tokenContainer.accessToken = nil
    tokenContainer.refreshToken = nil
    return response
  }

  @discardableResult
  func refreshTokens() -> Bool {
    guard let refreshToken = tokenContainer.refreshToken else { return false }
    let refreshRequest = NetworkRequest(method: .post,
                                        path: "https://getwhalergo.herokuapp.com/api/user/refresh",
                                        headers: authorizationHeader,
                                        params: [:],
                                        jsonBody: ["refreshToken": refreshToken])
    let result = networker.execute(request: refreshRequest)

    guard let data = result.data else { return false }
    let response: Response<User>
    
    do {
      response = try JSONDecoder().decode(Response<User>.self, from: data)
      switch response.result {
      case .value(let userResponse):
        Lifecycle.currentUser = userResponse.response
      case .error(_, _):
        break
      }
    } catch let error {
      //log.error(error)
      print(error)
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
      tokenContainer.accessToken = accessToken
      tokenContainer.refreshToken = refreshToken
      return true
    }
  }
}

struct EmptyRemote: Codable {}
struct AnyCodable: Codable {}
