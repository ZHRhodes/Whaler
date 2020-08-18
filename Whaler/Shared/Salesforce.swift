//
//  Salesforce.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/7/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

class Salesforce {
  static var accessToken = ""
  static var refreshToken = ""
  
  static private let networker: Networker.Type = JustNetworker.self
  
  static func fetchAllAccountsNotStartingWith(_ word: String) -> [Salesforce.QueryResponse<Salesforce.Account>] {
    let query = "SELECT name,type from Account WHERE (NOT type like '\(word)%')"
    let salesforceQuery = Salesforce.query(from: query)
    
    let request = NetworkRequest<Account>(method: .get,
                                 path: "https://na111.salesforce.com/services/data/v37.0/query",
                                 headers: ["Authorization": "Bearer \(Salesforce.accessToken)"],
                                 params: ["q": salesforceQuery],
                                 body: nil)
    let result = Salesforce.networker.execute(request: request)
    guard let data = result.data,
          let resultAsResponse = try? JSONDecoder().decode([QueryResponse<Salesforce.Account>].self, from: data) else {
      return []
    }
    return resultAsResponse
  }
  
  static func query(from query: String) -> String {
    let query = query.replacingOccurrences(of: " ", with: "+")
    return query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
  }
  
  struct QueryResponse<T: Decodable>: Decodable {
    let totalSize: Int?
    let done: Bool?
    let records: [T]?
  }
  
  struct Account: Codable {
    let Name: String?
//    let `Type`: String?
    let attributes: Attributes?
    
    class Attributes: Codable {
      let type: String?
      let url: String?
    }
  }
}

