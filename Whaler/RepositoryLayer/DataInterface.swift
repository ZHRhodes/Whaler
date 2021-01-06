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
  associatedtype RequestAllType
  associatedtype RequestSingleType
  associatedtype RequestSubsetType
  
  func fetchAll(with dataRequest: RequestAllType?) -> AnyPublisher<[RepoStorable], Error>
  func fetchSubset(_ dataRequest: RequestSubsetType?) -> AnyPublisher<[RepoStorable], Error>
  func fetchSingle(_ dataRequest: RequestSingleType?) -> AnyPublisher<RepoStorable, Error>
}
