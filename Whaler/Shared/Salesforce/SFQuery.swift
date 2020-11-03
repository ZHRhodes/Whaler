//
//  SFQuery.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/2/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

extension SF {
  struct Query {
    let value: String
    
    func From(_ object: SFObject.Type) -> Query {
      return Query(value: value + object.name)
    }
    
    func Where(_ filters: SoqlProviding...) -> Query {
      return Query(value: value + " WHERE (" + filters.map { $0.soql }.joined(separator: ") OR (") + ")")
    }
  }
  
  static func Select(_ properties: String) -> Query {
    return Query(value: "SELECT \(properties) FROM ")
  }
}
