//
//  Repository.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/23/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Combine

class Repository<Interface: DataInterface> {
  typealias Entity = Interface.Entity
  
  private var subject = CurrentValueSubject<[Entity], Error>([])
  private var dataInterface: Interface
  private var allCancellable: AnyCancellable?
  private var subsetCancellable: AnyCancellable?
  private var singleCancellable: AnyCancellable?
  private var replaceCancellable: AnyCancellable?
  
  var type: Entity.Type {
    return Entity.self
  }
  
  var publisher: AnyPublisher<[Entity], Error> {
    return subject.eraseToAnyPublisher()
  }
  
  init(dataInterface: Interface) {
    self.dataInterface = dataInterface
  }
  
  func broadcast(newValues: [Entity]) {
    subject.send(newValues)
  }
  
  @discardableResult
  func fetchAll(dataRequest: Interface.AllDataRequestType? = nil) -> AnyPublisher<[Entity], Error> {
    allCancellable = dataInterface
      .fetchAll(with: dataRequest)
      .sink(receiveCompletion: { (status) in
        switch status {
        case .finished:
          break
        case .failure(_):
          Log.error(String(describing: status))
        }
    }, receiveValue: { (data) in
      self.broadcast(newValues: data)
    })
    
    return publisher
  }
  
  func fetchSubset(dataRequest: Interface.SubsetDataRequestType) -> AnyPublisher<[Entity], Error> {
    let publisher = dataInterface.fetchSubset(with: dataRequest)
    subsetCancellable = updateWithFetchedSubset(publisher: publisher)
    return publisher
  }
  
  func fetchSingle(dataRequest: Interface.SingleDataRequestType) -> AnyPublisher<Entity, Error> {
    let publisher = dataInterface.fetchSingle(with: dataRequest)
    singleCancellable = updateWithFetchedSingle(publisher: publisher)
    return publisher
  }
  
  func save(_ set: [Entity]) -> AnyPublisher<[Entity], Error> {
    return dataInterface.save(set)
  }
  
  //MARK: Private Methods
  
  private func updateWithFetchedSubset(publisher: AnyPublisher<[Entity], Error>) -> AnyCancellable {
    return publisher
      .sink(receiveCompletion: { (status) in
      switch status {
      case .finished:
        break
      case .failure(let error):
        Log.error(String(describing: error))
      }
    }, receiveValue: { [weak self] (newValue) in
      guard let strongSelf = self else { return }
      var currentValues = strongSelf.subject.value
      currentValues = strongSelf.update(set: currentValues, with: newValue)
      strongSelf.broadcast(newValues: currentValues)
    })
  }
  
  private func updateWithFetchedSingle(publisher: AnyPublisher<Entity, Error>) -> AnyCancellable {
    let publisher = publisher.map { (entity) -> [Entity] in
      return [entity]
    }.eraseToAnyPublisher()
    return updateWithFetchedSubset(publisher: publisher)
  }
  
  private func update(set: [Entity], with new: [Entity]) -> [Entity] {
    var dict = [String: Entity]()
    set.forEach({ dict[$0.id] = $0 })
    
    new.forEach { (newEntity) in
      dict[newEntity.id] = newEntity
    }
    
    return Array(dict.values)
  }
  
  //function to clear cache?
}
