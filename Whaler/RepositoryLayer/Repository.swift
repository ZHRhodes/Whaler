//
//  Repository.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/23/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Combine

//protocol Repository {
////  func publisher<T: RepoStorable>() -> AnyPublisher<[T], Error>
//
//
////
//////  func subscribeChanges() -> AnyPublisher<Entity, Error>
////  func observeAll() -> AnyPublisher<[Entity], Error>
//////  func get(id: String) -> AnyPublisher<Entity?, Error>
//////  func add(_ entity: Entity) -> AnyPublisher<Entity, Error>
//////  func delete(id: String) -> AnyPublisher<Void, Error>
////
////  init()
//}

protocol RepoStorable {
  var id: String { get }
}

class RepoStore {
  var accountRepository = Repository<Account>(dataInterface:
                                                AccountDataInterface(
                                                  remoteDataSource: AccountRemoteDataSource(),
                                                                                   
                                                  sfDataSource: AccountSFDataSource()))
}

//enum Repo {
//  static func `for`<T: RepoStorable>(_ type: T.Type, using repoStore: RepoStore) -> Repository {
//    switch type {
//    case is Account.Type:
//      return repoStore.accountRepository
//    default:
//      fatalError("Repository not implemented for type \(type)")
//    }
//  }
//}

struct Repository<Entity: RepoStorable> {
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
  
  mutating func fetchAll() {
    cancellable = _fetchAll()
  }
  
  private func _fetchAll() -> AnyCancellable {
    return dataInterface
      .fetchAll()
      .sink(receiveCompletion: { (status) in
      print(status)
    }, receiveValue: { (data) in
      guard let entities = data as? [Entity] else { return }
      self.broadcast(newValues: entities)
    })
  }
}

protocol DataInterface {
  func fetchAll() -> AnyPublisher<[RepoStorable], Error>
}

class AccountDataInterface: DataInterface {
  private let remoteDataSource: AccountDataSource
  private let sfDataSource: AccountDataSource
  private var cancellable: AnyCancellable?
  
  init(remoteDataSource: AccountDataSource,
       sfDataSource: AccountDataSource) {
    self.remoteDataSource = remoteDataSource
    self.sfDataSource = sfDataSource
  }
  
  func fetchAll() -> AnyPublisher<[RepoStorable], Error> {
    return Future<[RepoStorable], Error> { [weak self] promise in
      guard let strongSelf = self else { return }
      strongSelf.cancellable = strongSelf.remoteDataSource
        .fetchAll()
        .zip(strongSelf.sfDataSource.fetchAll())
        .sink { (status) in
        print(status)
      } receiveValue: { (remoteAccounts, sfAccounts) in
        sfAccounts.forEach { account in
          if let matchingLocalAccount = remoteAccounts.first(where: { $0.salesforceID == account.salesforceID }) {
            account.mergeLocalProperties(with: matchingLocalAccount)
          }
        }
        promise(.success(sfAccounts))
      }
    }.eraseToAnyPublisher()
  }
}

protocol AccountDataSource {
  func fetchAll() -> AnyPublisher<[Account], Error>
}

struct AccountRemoteDataSource: AccountDataSource {
  func fetchAll() -> AnyPublisher<[Account], Error> {
    return Future<[Account], Error> { promise in
      promise(.success([Account()]))
    }.eraseToAnyPublisher()
  }
}

struct AccountSFDataSource: AccountDataSource {
  func fetchAll() -> AnyPublisher<[Account], Error> {
    return Future<[Account], Error> { promise in
      promise(.success([Account()]))
    }.eraseToAnyPublisher()
  }
}

/*
 Repo.subscribeAll<ExpenseReport>()
 
 Repo.for(Account.self, using: context.repoStore).publisher.sink { }
*/
