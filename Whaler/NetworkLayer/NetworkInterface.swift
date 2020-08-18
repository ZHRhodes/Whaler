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
  func post<B: Encodable, R: Codable>(path: String, body: B?) -> R
  func get<R: Codable>(path: String, params: [String : String]) -> R
//  func logOut()
//  func refreshTokens() -> Bool
}
////
//struct Network: NetworkInterface {
//  private let networker: Networker.Type = JustNetworker.self
//
//  private var authorizationHeader: [String: String] {
//    return ["Authorization": Network.accessToken ?? ""]
//  }
//
//  func post<B: Encodable, R: Codable>(path: String, body: B?) -> R {
//    let request = NetworkRequest(method: .post,
//                                 path: path,
//                                 headers: authorizationHeader,
//                                 params: [:],
//                                 body: body)
//    return execute(request: request)
//  }
//
//  func get<R: Codable>(path: String, params: [String : String]) -> R {
//    let body: Bool? = nil
//    let request = NetworkRequest(method: .get,
//                                 path: path,
//                                 headers: authorizationHeader,
//                                 params: params,
//                                 body: body)
//    return execute(request: request)
//  }
//
//  private func execute<B: Encodable, R: Codable>(request: NetworkRequest<B>) -> R {
//    var result = networker.execute(request: request)
//
//    if result.statusCode == 403 {
////      refreshTokens()
//      result = networker.execute(request: request)
//    }
//
//    if result.statusCode == 401 {
////      NotificationCenter.default.post(name: .unauthorizedUser, object: nil)
//    }
//
//    if !result.ok {
//      log.warning("Request \(request.path) failed with status code \(String(describing: result.statusCode))", context: LoggingContext.rest)
//      return Response<R>(code: result.statusCode ?? -1, message: "")
//    }
//
//    guard let data = result.data,
//      let response = try? JSONDecoder().decode(Response<R>.self, from: data) else {
//      //couldn't decode the response in the way we expected, log it
//        log.error("Failed to decode response from \(request.path)", context: LoggingContext.rest)
//        return Response<R>(.failedToDecodeResultData)
//    }
//    switch response.result {
//    case .error(let code, let message):
//      log.error("Error from request path \(request.path) -- Code: \(code), Message: \(message)", context: LoggingContext.rest)
//      if code == 4004 {
//        NotificationCenter.default.post(name: .unauthorizedUser, object: nil)
//      }
//    case .value(let rResponse):
//      if let accessToken = rResponse.tokens?.accessToken, !accessToken.isEmpty {
//        Network.accessToken = accessToken
//      }
//
//      if let refreshToken = rResponse.tokens?.refreshToken, !refreshToken.isEmpty {
//        Network.refreshToken = refreshToken
//      }
//    }
//
//    return response
//  }
//
////  @discardableResult
////  func logOut() -> Response<EmptyRemote> {
////    let body = [String: String]()
////    let response: Response<EmptyRemote> = post(path: "/api/user/logout", body: body)
////    return response
////  }
//
////  @discardableResult
////  func refreshTokens() -> Bool {
////    let refreshToken = ["refreshToken": Network.refreshToken]
////    let refreshRequest = NetworkRequest(method: .post,
////                                        path: "/api/user/refresh",
////                                        headers: authorizationHeader,
////                                        params: [:],
////                                        body: refreshToken)
////    let result = networker.execute(request: refreshRequest)
////
////    guard let data = result.data,
////      let response = try? JSONDecoder().decode(Response<AnyCodable?>.self, from: data) else {
////        //log and do something
////        return false
////    }
////
////    switch response.result {
////    case .error(let code, let message):
////      log.error("Error from request path /api/user/refresh -- Code: \(code), Message: \(message)", context: LoggingContext.rest)
////      return false
////    case .value(let tokensResponse):
////      guard let accessToken = tokensResponse.tokens?.accessToken,
////        let refreshToken = tokensResponse.tokens?.refreshToken else {
////          return false
////      }
////      Network.accessToken = accessToken
////      Network.refreshToken = refreshToken
////      return true
////    }
////  }
//
//  private struct AnyCodable: Codable {}
//}
//
//
