//
//  FilterOptionsProviding.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/20/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

protocol FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterOption]) -> Void)
}

struct BaseOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterOption]) -> Void) {
    let options: [FilterOption] = [
      FilterOption(group: .owner,
                   name: "Owner",
                   optionsProvider: OwnerOptionsProvider()),
      FilterOption(group: .industry,
                   name: "Industry",
                   optionsProvider: IndustryOptionsProvider()),
      FilterOption(group: .state,
                   name: "State",
                   optionsProvider: StateOptionsProvider()),
      FilterOption(group: .state,
                   name: "City",
                   optionsProvider: StateOptionsProvider())
    ]
    completion(options)
  }
}

struct OwnerOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterOption]) -> Void) {
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
  func fetchOptions(completion: @escaping ([FilterOption]) -> Void) {
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
  func fetchOptions(completion: @escaping ([FilterOption]) -> Void) {
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

struct CityOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterOption]) -> Void) {
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
