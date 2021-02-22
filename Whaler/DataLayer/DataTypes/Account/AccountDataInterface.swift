//
//  AccountDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 1/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class AccountDataInterface: DataInterface {
  typealias Entity = Account
  
  typealias AllDataRequestType = Void
  typealias SubsetDataRequestType = Void
  typealias SingleDataRequestType = Void
  
  typealias DataSaveType = Void
  
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
      self?.reconcileAccountsFromSalesforce(remoteAccounts: remoteAccounts, salesforceAccounts: sfAccounts)
      subject.send(sfAccounts)
      guard let strongSelf = self else { return }
      strongSelf.saveCancellable = strongSelf.remoteDataSource.saveAll(sfAccounts)
        .sink(receiveCompletion: { subject.send(completion: $0) },
              receiveValue: { subject.send($0) })
    }
    
    return subject.eraseToAnyPublisher()
  }
  
  func fetchSubset(with dataRequest: SubsetDataRequestType) -> AnyPublisher<[Entity], RepoError> {
    fatalError()
  }
  
  func fetchSingle(with dataRequest: SingleDataRequestType) -> AnyPublisher<Entity?, RepoError> {
    fatalError()
  }
  
  func save(_ data: DataSaveType) -> AnyPublisher<[Entity], RepoError> {
    fatalError()
  }

  //Mark: Private Methods
  
  private func reconcileAccountsFromSalesforce(remoteAccounts: [Account], salesforceAccounts: [Account]) {
    salesforceAccounts.forEach { account in
      if let matchingLocalAccount = remoteAccounts.first(where: { $0.salesforceID == account.salesforceID }) {
        account.mergeLocalProperties(with: matchingLocalAccount)
      }
    }
  }}