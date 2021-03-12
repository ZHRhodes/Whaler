//
//  FilterProvider.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/11/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

protocol FilterProviding {
  var name: String { get }
  var optionsProvider: FilterOptionsProvider? { get }
}

protocol FilterOptionsProvider {
  func fetchOptions(completion: ([String]) -> Void)
}

struct FilterProvider: FilterProviding {
  var name: String
  var optionsProvider: FilterOptionsProvider?
}
