//
//  MockAccountInterface.swift
//  WhalerTests
//
//  Created by Zachary Rhodes on 1/9/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine
@testable import Whaler

class MockAccountInterface: DataInterface {  
  typealias Entity = Account
  
  typealias AllDataRequestType = [Entity]
  typealias SubsetDataRequestType = [Entity]
  typealias SingleDataRequestType = Entity

  typealias DataSaveType = [Entity]
  
  func fetchAll(with dataRequest: AllDataRequestType?) -> AnyPublisher<[Entity], Error> {
    return Future<[Entity], Error> { promise in
      guard let request = dataRequest else { return }
      promise(.success(request))
    }.eraseToAnyPublisher()
  }
  
  func fetchSubset(with dataRequest: SubsetDataRequestType) -> AnyPublisher<[Entity], Error> {
    return Future<[Entity], Error> { promise in
      promise(.success(dataRequest))
    }.eraseToAnyPublisher()
  }
  
  func fetchSingle(with dataRequest: SingleDataRequestType) -> AnyPublisher<Entity, Error> {
    return Future<Entity, Error> { promise in
      promise(.success(dataRequest))
    }.eraseToAnyPublisher()
  }
  
  func save(_ data: DataSaveType) -> AnyPublisher<[Entity], Error> {
    return Future<[Entity], Error> { promise in
      promise(.success(data))
    }.eraseToAnyPublisher()
  }
}

