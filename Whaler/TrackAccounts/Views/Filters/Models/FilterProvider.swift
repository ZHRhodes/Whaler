//
//  FilterProvider.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/11/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

enum FilterGroup: String {
  case base = "Base",
       owner = "Owner",
       industry = "Industry",
       revenue = "Revenue",
       state = "State"
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
      FilterOption(group: .state,
                   name: "Revenue",
                   optionsProvider: StateOptionsProvider())
    ]
    completion(options)
  }
}

struct OwnerOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterProviding]) -> Void) {
    DispatchQueue.global().async {
      let owners = SFHelper.queryPossibleOwners()
      let options = owners.map { (name) -> FilterOption in
        return FilterOption(group: .owner,
                            name: name,
                            optionsProvider: nil)
      }
      DispatchQueue.main.async {
        completion(options)
      }
    }
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

struct StateOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterProviding]) -> Void) {
    DispatchQueue.global().async {
      let states = SFHelper.queryPossibleBillingStates()
      let options = states.map { (name) -> FilterOption in
        return FilterOption(group: .state,
                            name: name,
                            optionsProvider: nil)
      }
      DispatchQueue.main.async {
        completion(options)
      }
    }
  }
}
