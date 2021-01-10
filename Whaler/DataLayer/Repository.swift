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
  private var saveCancellable: AnyCancellable?
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
  func fetchAll(with dataRequest: Interface.AllDataRequestType? = nil) -> AnyPublisher<[Entity], Error> {
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
  
  func fetchSubset(with dataRequest: Interface.SubsetDataRequestType) -> AnyPublisher<[Entity], Error> {
    let publisher = dataInterface.fetchSubset(with: dataRequest)
    subsetCancellable = processNewResults(from: publisher)
    return publisher
  }
  
  func fetchSingle(with dataRequest: Interface.SingleDataRequestType) -> AnyPublisher<Entity, Error> {
    let publisher = dataInterface.fetchSingle(with: dataRequest)
    singleCancellable = processNewResult(from: publisher)
    return publisher
  }
  
  func save(_ data: Interface.DataSaveType) -> AnyPublisher<[Entity], Error> {
    let publisher = dataInterface.save(data)
    saveCancellable = processNewResults(from: publisher)
    return publisher.eraseToAnyPublisher()
  }
  
  //MARK: Private Methods
  
  private func processNewResults(from publisher: AnyPublisher<[Entity], Error>) -> AnyCancellable {
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
      currentValues = strongSelf.update(values: currentValues, with: newValue)
      strongSelf.broadcast(newValues: currentValues)
    })
  }
  
  private func processNewResult(from publisher: AnyPublisher<Entity, Error>) -> AnyCancellable {
    let publisher = publisher.map { (entity) -> [Entity] in
      return [entity]
    }.eraseToAnyPublisher()
    return processNewResults(from: publisher)
  }
  
  private func update(values: [Entity], with new: [Entity]) -> [Entity] {
    var values = values
    var dict = [String: Entity]()
    new.forEach({ dict[$0.id] = $0 })
    
    values.enumerated().forEach { (index, element) in
      if let matchInNew = dict[element.id] {
        values[index] = matchInNew
      }
    }
    
    return values
  }
  
  //function to clear cache?
}
