//
//  AccountDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 1/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

enum AccountSaveType {
  case valueChange([Account]), trackingChange([TrackingChange<Account>])
}

class AccountDataInterface: DataInterface {
  typealias Entity = Account
  
  typealias AllDataRequestType = Void
  typealias SubsetDataRequestType = Set<Filter>
  typealias SingleDataRequestType = Void
  
  typealias DataSaveType = AccountSaveType
  
  private let remoteDataSource: AccountRemoteDataSource
  private let sfDataSource: AccountSFDataSource
  private var cancellable: AnyCancellable?
  private var saveCancellable: AnyCancellable?
  
  init(remoteDataSource: AccountRemoteDataSource,
       sfDataSource: AccountSFDataSource) {
    self.remoteDataSource = remoteDataSource
    self.sfDataSource = sfDataSource
  }
  
  func fetchAll(with dataRequest: AllDataRequestType?) -> AnyPublisher<[Entity], RepoError> {
    let subject = PassthroughSubject<[Entity], RepoError>()
    
    subject.send(ObjectManager.retrieveAll(ofType: Account.self))
    
    cancellable = remoteDataSource
      .fetchAll()
      .zip(sfDataSource.fetchAll())
      .sink { (status) in
        switch status {
        case .finished:
          break
        case .failure(_):
          subject.send(completion: status)
        }
    } receiveValue: { [weak self] (remoteAccounts, sfAccounts) in
      guard let strongSelf = self else { return }
      let mergedAccounts = strongSelf.reconcileAccountsFromSalesforce(remoteAccounts: remoteAccounts, salesforceAccounts: sfAccounts)
      subject.send(mergedAccounts)
      strongSelf.saveCancellable = strongSelf.remoteDataSource.saveAll(remoteAccounts)
        .sink(receiveCompletion: { subject.send(completion: $0) },
              receiveValue: { subject.send($0) })
    }
    
    return subject.eraseToAnyPublisher()
  }
  
  func fetchSubset(with dataRequest: SubsetDataRequestType) -> AnyPublisher<[Entity], RepoError> {
    return sfDataSource.fetchSubset(with: dataRequest)
  }
  
  func fetchSingle(with dataRequest: SingleDataRequestType) -> AnyPublisher<Entity?, RepoError> {
    fatalError()
  }
  
  func save(_ data: DataSaveType) -> AnyPublisher<[Entity], RepoError> {
    switch data {
    case .valueChange(let accounts):
      return saveValueChanges(accounts)
    case .trackingChange(let trackingChanges):
      return saveTrackingChanges(trackingChanges)
    }
  }
  
  private func saveValueChanges(_ accounts: [Account]) -> AnyPublisher<[Entity], RepoError> {
    Future<[Entity], RepoError> { promise in
      self.saveCancellable = self.remoteDataSource
        .saveAll(accounts)
        .sink(receiveCompletion: { _ in }) { (accounts) in
          accounts.forEach { ObjectManager.save($0) }
          promise(.success(accounts))
      }
    }.eraseToAnyPublisher()
  }
  
  private func saveTrackingChanges(_ trackingChanges: [TrackingChange<Account>]) -> AnyPublisher<[Entity], RepoError> {
    Future<[Entity], RepoError> { promise in
      self.saveCancellable = self.remoteDataSource
        .saveTrackingChanges(trackingChanges)
        .sink(receiveCompletion: { _ in }) { (accounts) in
          accounts.forEach { ObjectManager.save($0) }
          promise(.success(accounts))
      }
    }.eraseToAnyPublisher()
  }

  //Mark: Private Methods
  
  private func reconcileAccountsFromSalesforce(remoteAccounts: [Account], salesforceAccounts: [Account]) -> [Account] {
    var mergedAccounts = remoteAccounts
    remoteAccounts.enumerated().forEach { (index, remoteAccount) in
      if let matchingSalesforceAccount = salesforceAccounts.first(where: { $0.salesforceID == remoteAccount.salesforceID }) {
        mergedAccounts[index] = mergeLocalProperties(from: remoteAccount, into: matchingSalesforceAccount)
      }
    }
    return mergedAccounts
  }
  
  private func mergeLocalProperties(from sourceAccount: Account, into destinationAccount: Account) -> Account {
    destinationAccount.id = sourceAccount.id
    destinationAccount.state = sourceAccount.state
    destinationAccount.notes = sourceAccount.notes
    return destinationAccount
  }
}
