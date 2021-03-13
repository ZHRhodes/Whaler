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
                   optionsProvider: OwnerOptionsProvider()),
      FilterOption(group: .industry,
                   name: "Industry",
                   optionsProvider: IndustryOptionsProvider()),
      FilterOption(group: .revenue,
                   name: "Revenue",
                   optionsProvider: nil)
    ]
    completion(options)
  }
}

struct OwnerOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterProviding]) -> Void) {
    guard let orgUsers = Lifecycle.currentUser?.organization?.users else { return }
    let options: [FilterOption] = orgUsers.map { (user) -> FilterOption in
      return FilterOption(group: .owner,
                          name: user.fullName,
                          optionsProvider: nil)
    }
    completion(options)
  }
}

struct IndustryOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterProviding]) -> Void) {
    DispatchQueue.global().async {
      let industries = SFHelper.queryPossibleIndustries()
      let options = industries.map { (name) -> FilterOption in
        return FilterOption(group: .industry,
                            name: name,
                            optionsProvider: nil)
      }
      DispatchQueue.main.async {
        completion(options)
      }
    }
  }
}
