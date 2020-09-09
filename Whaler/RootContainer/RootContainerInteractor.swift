//
//  RootContainerInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/4/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Combine

struct RootContainerInteractor {
  let unauthorizedUserPublisher: NotificationCenter.Publisher

  init() {
    unauthorizedUserPublisher = NotificationCenter.Publisher(center: .default, name: .unauthorizedUser)
  }
}
