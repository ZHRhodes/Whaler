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
  
  typealias SubsetDataSaveType = Void
  typealias SingleDataSaveType = Void
  
  private let remoteDataSource: AccountDataSource
  private let sfDataSource: AccountDataSource
  private var cancellable: AnyCancellable?
  private var saveCancellable: AnyCancellable?
  
  init(remoteDataSource: AccountDataSource,
       sfDataSource: AccountDataSource) {
    self.remoteDataSource = remoteDataSource
    self.sfDataSource = sfDataSource
  }
  
  func fetchAll(with dataRequest: AllDataRequestType?) -> AnyPublisher<[Entity], Error> {
    let subject = PassthroughSubject<[Entity], Error>()
    
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
  
  func fetchSubset(with dataRequest: SubsetDataRequestType?) -> AnyPublisher<[Entity], Error> {
    fatalError()
  }
  
  func fetchSingle(with dataRequest: SingleDataRequestType?) -> AnyPublisher<Entity, Error> {
    fatalError()
  }
  
  func save(_ set: [Entity]) -> AnyPublisher<[Entity], Error> {
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
