//
//  NetworkInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/16/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

protocol NetworkInterface {
  func post<B: Encodable, R: Codable>(path: String, jsonBody: B?) -> Response<R>
  func post<R: Codable>(path: String, formBody: [String: String]) -> Response<R>
  func get<R: Codable>(path: String, params: [String : String]) -> Response<R>
}

struct EmptyRemote: Codable {}
struct AnyCodable: Codable {}
