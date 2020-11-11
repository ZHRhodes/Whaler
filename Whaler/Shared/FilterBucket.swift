//
//  FilterBucket.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/2/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

typealias Bound<T> = (bound: T, displayUnits: String)

struct FilterBucket<T> {
  let lowerBound: Bound<T>
  let upperBound: Bound<T>?
  
  //SoqlProviding
  var soqlProperty: String = ""
}

extension FilterBucket: NameProviding {
  var name: String {
    if let upperBound = upperBound {
      return "\(lowerBound.bound) \(lowerBound.displayUnits) - \(upperBound.bound) \(upperBound.displayUnits)"
    } else {
      return "\(lowerBound.bound) \(lowerBound.displayUnits)+"
    }
  }
}

extension FilterBucket: SoqlProviding {
  var soql: String {
    guard !soqlProperty.isEmpty else {
      Log.error("Must set soqlProperty name before accessing soql")
      return ""
    }
    var soql = "\(soqlProperty) >= \(lowerBound.bound)"
    if let upperBound = upperBound {
      soql.append(" AND \(soqlProperty) <= \(upperBound.bound)")
    }
    return soql
  }
}
