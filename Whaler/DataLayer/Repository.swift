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
  
  //add tests for storing last fetched or not //todo next: write these tests
  
  private lazy var currentValueSubject = CurrentValueSubject<[Entity], RepoError>([])
  private lazy var passthroughSubject = PassthroughSubject<[Entity], RepoError>()
  var passthroughMode: Bool
  private let dataInterface: Interface
  private var allCancellable: AnyCancellable?
  private var subsetCancellable: AnyCancellable?
  private var singleCancellable: AnyCancellable?
  private var saveCancellable: AnyCancellable?
  
  private lazy var queue = DispatchQueue(label: "com.whaler.\(String(describing: type.self))")
  
  var type: Entity.Type {
    return Entity.self
  }
  
  var publisher: AnyPublisher<[Entity], RepoError> {
    return passthroughMode ?
      passthroughSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher() :
      currentValueSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
  
  init(dataInterface: Interface, passthroughMode: Bool = false) {
    self.dataInterface = dataInterface
    self.passthroughMode = passthroughMode
  }
  
  func broadcast(newValues: [Entity]) {
    if passthroughMode {
      passthroughSubject.send(newValues)
    } else {
      currentValueSubject.send(newValues)
    }
  }
  
  @discardableResult
  func fetchAll(with dataRequest: Interface.AllDataRequestType? = nil) -> AnyPublisher<[Entity], RepoError> {
    let interface = dataInterface
    queue.async { [weak self] in
      self?.allCancellable = interface
        .fetchAll(with: dataRequest)
        .sink(receiveCompletion: { (completion) in
          switch completion {
          case .finished:
            break
          case .failure(_):
            Log.error(String(describing: completion))
          }
      }, receiveValue: { [weak self] (data) in
        self?.broadcast(newValues: data)
      })
    }
    return publisher
  }
  
  func fetchSubset(with dataRequest: Interface.SubsetDataRequestType) -> AnyPublisher<[Entity], RepoError> {
    return Future<[Entity], RepoError> { [weak self] promise in
      self?.queue.async { [weak self] in
        guard let strongSelf = self else { return }
        let publisher = strongSelf.dataInterface
          .fetchSubset(with: dataRequest)

        strongSelf.subsetCancellable = publisher.sink { (completion) in
          if case let .failure(error) = completion {
            Log.error(String(describing: error))
            promise(.failure(error))
          }
        } receiveValue: { [weak self] (value) in
          self?.processNewResults(value)
          promise(.success(value))
        }
      }
    }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
  
  func fetchSingle(with dataRequest: Interface.SingleDataRequestType) -> AnyPublisher<Entity?, RepoError> {
    return Future<Entity?, RepoError> { [weak self] promise in
      self?.queue.async { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.singleCancellable = strongSelf.dataInterface
          .fetchSingle(with: dataRequest)
          .sink { (completion) in
          if case let .failure(error) = completion {
            Log.error(String(describing: error))
            promise(.failure(error))
          }
        } receiveValue: { [weak self] (value) in
          if let value = value {
            self?.processNewResult(value)
          }
          promise(.success(value))
        }
      }
    }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
  
  func save(_ data: Interface.DataSaveType) -> AnyPublisher<[Entity], RepoError> {
    return Future<[Entity], RepoError> { [weak self] promise in
      self?.queue.async { [weak self] in
        guard let strongSelf = self else { return }
        let publisher = strongSelf.dataInterface
          .save(data)

        strongSelf.saveCancellable = publisher.sink { (completion) in
          if case let .failure(error) = completion {
            Log.error(String(describing: error))
            promise(.failure(error))
          }
        } receiveValue: { [weak self] (value) in
          self?.processNewResults(value)
          promise(.success(value))
        }
      }
    }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
  
  //MARK: Private Methods
  
  private func processNewResults(_ results: [Entity]) {
    if passthroughMode {
      broadcast(newValues: results)
    } else {
      var currentValues = currentValueSubject.value
      currentValues = update(values: currentValues, with: results)
      broadcast(newValues: currentValues)
    }
  }
  
  private func processNewResult(_ result: Entity) {
    return processNewResults([result])
  }
  
  private func update(values: [Entity], with new: [Entity]) -> [Entity] {
    var values = values
    var dict = [String: Entity]()
    new.forEach({ dict[$0.id] = $0 })
    
    values.enumerated().forEach { (index, element) in
      if let matchInNew = dict[element.id] {
        values[index] = matchInNew
        dict.removeValue(forKey: element.id)
      }
    }
    
    new.forEach { (newValue) in
      if let value = dict[newValue.id] {
        values.append(value)
      }
    }
        
    return values
  }
  
  //function to clear cache?
}
