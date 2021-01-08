//
//  Repository.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/23/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Combine

class Repository<Entity, Interface: DataInterface> where Interface.Entity == Entity {
  private var subject = CurrentValueSubject<[Entity], Error>([])
  private var dataInterface: Interface
  private var allCancellable: AnyCancellable?
  private var subsetCancellable: AnyCancellable?
  private var singleCancellable: AnyCancellable?
  
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
        Log.debug(String(describing: status))
    }, receiveValue: { (data) in
      self.broadcast(newValues: data)
    })
    
    return publisher
  }
  
  func fetchSubset(dataRequest: Interface.SubsetDataRequestType) -> AnyPublisher<[Entity], Error> {
    let subsetSubject = PassthroughSubject<[Entity], Error>()
    
    subsetCancellable = subject.sink(receiveCompletion: { _ in },
                                     receiveValue: { (currentValues) in
                                      var currentValues = currentValues
                                      self.subsetCancellable = self.dataInterface
                                        .fetchSubset(with: dataRequest)
                                        .flatMap({ $0.publisher })
                                        .sink(receiveCompletion: { (status) in
                                          switch status {
                                          case .finished:
                                            self.broadcast(newValues: currentValues)
                                          case .failure(let error):
                                            Log.error(String(describing: error))
                                          }
                                        }, receiveValue: { (newValue) in
                                          //use dict, key=id
                                          if let idx = currentValues.firstIndex(where: { $0.id == newValue.id }) {
                                            currentValues[idx] = newValue
                                          } else {
                                            currentValues.append(newValue)
                                          }
                                        })
                                     })
    
    return subsetSubject.eraseToAnyPublisher()
  }
  
  func fetchSingle(dataRequest: Interface.SingleDataRequestType) -> AnyPublisher<Entity, Error> {
    let singleSubject = PassthroughSubject<Entity, Error>()
    
    singleCancellable = subject.sink(receiveCompletion: { _ in },
                                     receiveValue: { (currentValues) in
                                      var currentValues = currentValues
                                      self.singleCancellable = self.dataInterface
                                        .fetchSingle(with: dataRequest)
                                        .sink(receiveCompletion: { (status) in
                                          switch status {
                                          case .finished:
                                            self.broadcast(newValues: currentValues)
//                                            self.singleCancellable = nil
                                          case .failure(let error):
                                            Log.error(String(describing: error))
                                          }
                                        }, receiveValue: { (newValue) in
                                          if let idx = currentValues.firstIndex(where: { $0.id == newValue.id }) {
                                            currentValues[idx] = newValue
                                          } else {
                                            currentValues.append(newValue)
                                          }
                                        })
    })
    
    return singleSubject.eraseToAnyPublisher()
  }
}
