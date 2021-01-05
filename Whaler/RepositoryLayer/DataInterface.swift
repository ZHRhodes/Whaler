//
//  DataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 1/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

protocol DataInterface {
  func fetchAll() -> AnyPublisher<[RepoStorable], Error>
}
