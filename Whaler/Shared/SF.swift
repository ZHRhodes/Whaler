//
//  Salesforce.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/7/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

class SF {
  static var accessToken = ""
  static var refreshToken = ""
  
  static private let networker: Networker.Type = JustNetworker.self
  
  static func query<T: Codable>(_ soql: String) throws -> [T] {
    let request = NetworkRequest<T>(method: .get,
                                 path: "https://na111.salesforce.com/services/data/v37.0/query",
                                 headers: ["Authorization": "Bearer \(SF.accessToken)"],
                                 params: ["q": soql],
                                 body: nil)
    let result = SF.networker.execute(request: request)
    guard let data = result.data else { return [] }
    let resultAsResponse: SF.QueryResponse<T>
    
    do {
      resultAsResponse = try JSONDecoder().decode(QueryResponse<T>.self, from: data)
    } catch let error {
      //TODO LOG
      print(error)
      throw error
    }
    
    return resultAsResponse.records ?? [T]()
  }
  
  struct QueryResponse<T: Decodable>: Decodable {
    let totalSize: Int?
    let done: Bool?
    let records: [T]?
  }
  
  struct Account: Codable {
    let Name: String?
    let `Type`: String?
    let attributes: Attributes?
    
    class Attributes: Codable {
      let type: String?
      let url: String?
    }
  }
}

