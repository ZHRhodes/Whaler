//
//  FilterValue.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/2/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct FilterValue {
  let name: String
  
  //SoqlProviding
  var soqlProperty: String = ""
}

extension FilterValue: NameProviding { }

extension FilterValue: SoqlProviding {
  var soql: String {
    return "\(soqlProperty) = '\(name)'"
  }
}
