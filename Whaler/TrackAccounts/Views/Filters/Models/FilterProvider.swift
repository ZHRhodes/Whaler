//
//  FilterProvider.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/11/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

enum FilterGroup {
  case base, owner, industry, revenue
}

protocol FilterProviding {
  var group: FilterGroup { get }
  var name: String { get }
  var optionsProvider: FilterOptionsProviding? { get }
}

struct FilterOption: FilterProviding {
  let group: FilterGroup
  let name: String
  var optionsProvider: FilterOptionsProviding?
}

protocol FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterProviding]) -> Void)
}

struct BaseOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterProviding]) -> Void) {
    let options: [FilterOption] = [
      FilterOption(group: .owner,
                   name: "Owner",
                   optionsProvider: nil),
      FilterOption(group: .industry,
                   name: "Industry",
                   optionsProvider: nil),
      FilterOption(group: .revenue,
                   name: "Revenue",
                   optionsProvider: nil)
    ]
    completion(options)
  }
}

struct FilterOptionsProviderFactory {
  static func provider(for filterGroup: FilterGroup) -> FilterOptionsProviding {
    switch filterGroup {
    case .base:
      return BaseOptionsProvider()
    case .owner:
      return OwnerOptionsProvider()
    case .industry:
      return BaseOptionsProvider()
    case .revenue:
      return BaseOptionsProvider()
    }
  }
}

struct OwnerOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterProviding]) -> Void) {
    
  }
}
