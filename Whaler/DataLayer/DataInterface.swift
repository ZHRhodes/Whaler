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
  associatedtype Entity: RepoStorable
  
  associatedtype AllDataRequestType
  associatedtype SubsetDataRequestType
  associatedtype SingleDataRequestType
  
  associatedtype DataSaveType
  
  func fetchAll(with dataRequest: AllDataRequestType?) -> AnyPublisher<[Entity], Error>
  func fetchSubset(with dataRequest: SubsetDataRequestType) -> AnyPublisher<[Entity], Error>
  func fetchSingle(with dataRequest: SingleDataRequestType) -> AnyPublisher<Entity, Error>
  
  func save(_ data: DataSaveType) -> AnyPublisher<[Entity], Error>
}
