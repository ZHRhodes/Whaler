//
//  TaskOptionsProvider.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/29/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct TaskOptionsProvider: SimpleItemProviding {
  func getItems(success: ([SimpleItem]) -> Void, failure: (Error) -> Void) {
    success(TaskOption.allCases)
  }
}
