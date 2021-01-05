//
//  Repository.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/23/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Combine

class Repository<Entity: RepoStorable> {
  private var subject = CurrentValueSubject<[Entity], Error>([])
  private var dataInterface: DataInterface
  private var cancellable: AnyCancellable?
  
  var type: Entity.Type {
    return Entity.self
  }
  
  var publisher: AnyPublisher<[Entity], Error> {
    return subject.eraseToAnyPublisher()
  }
  
  init(dataInterface: DataInterface) {
    self.dataInterface = dataInterface
  }
  
  func broadcast(newValues: [Entity]) {
    subject.send(newValues)
  }
  
  func fetchAll() {
    cancellable = dataInterface
      .fetchAll()
      .sink(receiveCompletion: { (status) in
      print(status)
    }, receiveValue: { (data) in
      guard let entities = data as? [Entity] else { return }
      self.broadcast(newValues: entities)
    })
  }
}
