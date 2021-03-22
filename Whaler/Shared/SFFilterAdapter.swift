//
//  SFFilterAdapter.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/21/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct SFFilterAdapter {
  let soql: Soql
  
  init(filter: Filter) {
    switch filter {
    case .owner(let owner):
      soql = "OwnerId = '\(owner.id)'"
    case .industry(let industry):
      soql = "Industry = '\(industry)'"
    case .revenue(let revenueRange):
      soql = ""
    case .state(let state):
      soql = "BillingState = '\(state)'"
    case .base:
      soql = ""
    }
  }
}

struct SFFilterBuilder {
  var soql: Soql
  
  init(filters: Set<Filter>) {
    var filterGrouper = Grouper<String, Filter>(groups: Filter.allGroups)
    filters.forEach { filterGrouper.append($0, to: $0.group) }
    var groupSoqls: [Soql] = []
    filterGrouper.groups.forEach { (group) in
      let values = filterGrouper[group]
      guard !values.isEmpty else { return }
      let groupSoql = values
        .map(SFFilterAdapter.init)
        .map{ $0.soql }
        .joined(separator: " OR ")
      groupSoqls.append("(\(groupSoql))")
    }
    soql = groupSoqls.joined(separator: " AND ")
  }
}
