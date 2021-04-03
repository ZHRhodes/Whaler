//
//  Repository.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/23/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Combine

class Repository<Interface: DataInterface>: EphemeralObject {
  typealias Entity = Interface.Entity
  
  /// The Entity type managed by this Repository.
  var type: Entity.Type {
    return Entity.self
  }
  
  private let isEphemeral: Bool
  private let ephemeralSessionManager: EphemeralSessionManager
  lazy var id: String = UUID().uuidString
  
  private lazy var currentValueSubject = CurrentValueSubject<[Entity], RepoError>([])
  private lazy var passthroughSubject = PassthroughSubject<[Entity], RepoError>()
  private let dataInterface: Interface
  private var allCancellable: AnyCancellable?
  private var subsetCancellable: AnyCancellable?
  private var singleCancellable: AnyCancellable?
  private var saveCancellable: AnyCancellable?
  
  private lazy var queue = DispatchQueue(label: "com.whaler.\(String(describing: type.self))")
  
  /// A publisher that will publish the most comprehensive dataset received by this Repository.
  ///
  /// If passthroughMode is disabled, then new subscribers to this publisher will receive all objects that have been fetched by this repository so far. If nothing has been fetched, then the default value is an empty array.
  ///
  /// New datasets will be published if functions are called that modify the current dataset of all values.
  ///
  /// Note: If passthroughMode is enabled, then only `fetchAll` will publish values to this publisher.
  var publisher: AnyPublisher<[Entity], RepoError> {
    if isEphemeral {
      return passthroughSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    } else {
      return currentValueSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
  }
  
  /// Creates an ephemeral instance of this repository type. Ephemeral instances are one-and-done; they fire one result set and deinit.
  /// They do not cache their results, nor do they affect the cache of the regular repository.
  ///
  /// This is useful for highly transient datasets, where a cached dataset would only take space in memory without providing any future value. Ex: Searched flights, where the flight objects are large and the rates are only good for a short amount of time.
  ///
  /// It's also useful for "exploring" data of a given type, where the results should not necessarily be associated with the user or session.
  var ephemeral: Repository<Interface> {
    let passthroughRepo = Self.init(dataInterface: dataInterface, ephemeralSessionManager: ephemeralSessionManager, ephemeral: true)
    ephemeralSessionManager.register(passthroughRepo)
    return passthroughRepo
  }
  
  required init(dataInterface: Interface, ephemeralSessionManager: EphemeralSessionManager, ephemeral: Bool = false) {
    self.dataInterface = dataInterface
    self.ephemeralSessionManager = ephemeralSessionManager
    self.isEphemeral = ephemeral
  }
  
  /// Sends a new set of values over the publisher determined by the passthroughMode value.
  ///
  /// - Parameter newValues: New values to be broadcasted
  func broadcast(newValues: [Entity]) {
    if isEphemeral {
      passthroughSubject.send(newValues)
    } else {
      currentValueSubject.send(newValues)
    }
  }
  
  /// Fetches all data via the DataInterface.
  ///
  /// It's common to subscribe to `Repository.publisher` before calling this function, which is why the result is discardable.
  ///
  /// - Parameter dataRequest: Type defined by the Interface type for this Repository instance. Optional with nil default for the common case that fetchAll requires no input to determine what to fetch.
  /// - Returns: A publisher that will emit the result of this fetchAll operation. Note: For a continuous stream of all fetched data, subscribe to `Repository.publisher` instead.
  @discardableResult
  func fetchAll(with dataRequest: Interface.AllDataRequestType? = nil) -> AnyPublisher<[Entity], RepoError> {
    return Future<[Entity], RepoError> { [weak self] promise in
      self?.queue.async { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.allCancellable = strongSelf.dataInterface
          .fetchAll(with: dataRequest)
          .sink { (completion) in
            if case let .failure(error) = completion {
              Log.error(String(describing: error))
              promise(.failure(error))
              strongSelf.unregisterEphemeralSessionIfNecessary()
            }
        } receiveValue: { (value) in
          strongSelf.broadcast(newValues: value)
          promise(.success(value))
          strongSelf.unregisterEphemeralSessionIfNecessary()
        }
      }
    }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
  
  /// Fetches a subset of data via the DataInterface.
  ///
  /// Unless it's an ephemeral repository, the fetched subset will be merged with all currently fetched data. The new current data set will be broadcast to the `Repository.publisher`.
  ///
  /// - Parameter dataRequest: Type defined by the Interface type for this Repository instance.
  /// - Returns: A publisher that will emit the result of this fetchSubset operation.
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
            strongSelf.unregisterEphemeralSessionIfNecessary()
          }
        } receiveValue: { [weak self] (value) in
          self?.processNewResults(value)
          promise(.success(value))
          strongSelf.unregisterEphemeralSessionIfNecessary()
        }
      }
    }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
  
  /// Fetches a single item of data via the DataInterface.
  ///
  /// Unless it's an ephemeral repository, the fetched single will be merged with all currently fetched data. The new current data set will be broadcast to the `Repository.publisher`.
  ///
  /// - Parameter dataRequest: Type defined by the Interface type for this Repository instance.
  /// - Returns: A publisher that will emit the result of this fetchSingle operation.
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
            strongSelf.unregisterEphemeralSessionIfNecessary()
          }
        } receiveValue: { [weak self] (value) in
          if let value = value {
            self?.processNewResult(value)
          }
          promise(.success(value))
          strongSelf.unregisterEphemeralSessionIfNecessary()
        }
      }
    }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
  
  /// Saves a dataset via the DataInterface.
  ///
  /// Unless it's an ephemeral repository, the saved data will be merged with all currently fetched data. The new current data set will be broadcast to the `Repository.publisher`.
  ///
  /// - Parameter data: Type defined by the DataInterface that's used to provide the data to save as well as any necessary parameters.
  /// - Parameter updatePolicy: Determines whether to merge the subset with the cache or two replace the cache entirely.
  /// - Returns: A publisher that will emit the result of this save operation.
  func save(_ data: Interface.DataSaveType, updatePolicy: UpdatePolicy = .subset) -> AnyPublisher<[Entity], RepoError> {
    return Future<[Entity], RepoError> { [weak self] promise in
      self?.queue.async { [weak self] in
        guard let strongSelf = self else { return }

        strongSelf.saveCancellable = strongSelf
          .dataInterface
          .save(data).sink { (completion) in
          if case let .failure(error) = completion {
            Log.error(String(describing: error))
            promise(.failure(error))
            strongSelf.unregisterEphemeralSessionIfNecessary()
          }
        } receiveValue: { [weak self] (value) in
          switch updatePolicy {
          case .subset:
            self?.processNewResults(value)
          case .all:
            self?.broadcast(newValues: value)
          }
          promise(.success(value))
          strongSelf.unregisterEphemeralSessionIfNecessary()
        }
      }
    }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
  
  //MARK: Private Methods
  
  private func processNewResults(_ results: [Entity]) {
    if !isEphemeral {
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
  
  private func unregisterEphemeralSessionIfNecessary() {
    if isEphemeral {
      ephemeralSessionManager.unregister(self)
    }
  }
}

extension Repository {
  enum UpdatePolicy {
    case subset, all
  }
}
