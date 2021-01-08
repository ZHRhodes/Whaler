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
  
  func fetchAll(with dataRequest: AllDataRequestType?) -> AnyPublisher<[Entity], Error>
  func fetchSubset(with dataRequest: SubsetDataRequestType?) -> AnyPublisher<[Entity], Error>
  func fetchSingle(with dataRequest: SingleDataRequestType?) -> AnyPublisher<Entity, Error>
}

//protocol DataRequestBuilder {
//  associatedtype RemoteRequestType
//  associatedtype LocalRequestType
//
//  func remoteRequest() -> RemoteRequestType
//  func localRequest() -> LocalRequestType
//}

//struct EmptyDataRequestBuilder: DataRequestBuilder {}
