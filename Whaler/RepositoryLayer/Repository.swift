//
//  Repository.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/23/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Combine

protocol DataRequestTypes {
  associatedtype All
  associatedtype Single
  associatedtype Subset
}

struct AccountRequestTypes: DataRequestTypes {
  typealias All = String
  typealias Single = String
  typealias Subset = String
}

class Repository<Entity: RepoStorable, Interface: DataInterface> {
  private var subject = CurrentValueSubject<[Entity], Error>([])
  private var dataInterface: Interface
  private var cancellable: AnyCancellable?
  
  var type: Entity.Type {
    return Entity.self
  }
  
  var publisher: AnyPublisher<[Entity], Error> {
    return subject.eraseToAnyPublisher()
  }
  
  //use keyvaluepairs or something similar to implement limited cache
  private var singlePublishers: [DataRequest: CurrentValueSubject<Entity, Error>] = [:]
  
  init(dataInterface: Interface) {
    self.dataInterface = dataInterface
  }
  
  func broadcast(newValues: [Entity]) {
    subject.send(newValues)
  }
  
  func fetchAll(dataRequest: Interface.RequestAllType? = nil) {
    cancellable = dataInterface
      .fetchAll(with: dataRequest)
      .sink(receiveCompletion: { (status) in
      print(status)
    }, receiveValue: { (data) in
      guard let entities = data as? [Entity] else { return }
      self.broadcast(newValues: entities)
    })
  }
  
  func fetchSubset(dataRequest: Interface.RequestSubsetType) {
    
  }
  
  func fetchSingle(dataRequest: Interface.RequestSingleType) {
    
  }
}
