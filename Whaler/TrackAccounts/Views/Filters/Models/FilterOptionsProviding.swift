//
//  FilterOptionsProviding.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/20/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

protocol FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterDisplayOption]) -> Void)
}

struct BaseOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterDisplayOption]) -> Void) {
    let options: [FilterDisplayOption] = [
      FilterDisplayOption(filter: .base,
                          valueDisplayName: "Owner",
                          optionsProvider: OwnerOptionsProvider()),
      FilterDisplayOption(filter: .base,
                          valueDisplayName: "Industry",
                          optionsProvider: IndustryOptionsProvider()),
      FilterDisplayOption(filter: .base,
                          valueDisplayName: "State",
                          optionsProvider: StateOptionsProvider()),
    ]
    completion(options)
  }
}

struct OwnerOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterDisplayOption]) -> Void) {
    DispatchQueue.global().async {
      let owners = SFHelper.queryPossibleOwners()
      let options = owners.map { (owner) -> FilterDisplayOption in
        return FilterDisplayOption(filter: .owner(owner),
                                   valueDisplayName: owner.name,
                                   optionsProvider: nil)
      }
      DispatchQueue.main.async {
        completion(options)
      }
    }
  }
}

struct IndustryOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterDisplayOption]) -> Void) {
    DispatchQueue.global().async {
      let industries = SFHelper.queryPossibleIndustries()
      let options = industries.map { (name) -> FilterDisplayOption in
        return FilterDisplayOption(filter: .industry(name),
                                   valueDisplayName: name,
                                   optionsProvider: nil)
      }
      DispatchQueue.main.async {
        completion(options)
      }
    }
  }
}

struct StateOptionsProvider: FilterOptionsProviding {
  func fetchOptions(completion: @escaping ([FilterDisplayOption]) -> Void) {
    DispatchQueue.global().async {
      let states = SFHelper.queryPossibleBillingStates()
      let options = states.map { (name) -> FilterDisplayOption in
        return FilterDisplayOption(filter: .state(name),
                                   valueDisplayName: name,
                                   optionsProvider: nil)
      }
      DispatchQueue.main.async {
        completion(options)
      }
    }
  }
}
