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
      print(status)
    } receiveValue: { [weak self] (remoteAccounts, sfAccounts) in
      self?.reconcileAccountsFromSalesforce(remoteAccounts: remoteAccounts, salesforceAccounts: sfAccounts)
      subject.send(sfAccounts)
      guard let strongSelf = self else { return }
      strongSelf.saveCancellable = strongSelf.remoteDataSource.saveAll(sfAccounts)
        .sink(receiveCompletion: { _ in }, receiveValue: { subject.send($0) })
    }
    
    return subject.eraseToAnyPublisher()
  }
  
  func fetchSubset(with dataRequest: SubsetDataRequestType?) -> AnyPublisher<[Entity], Error> {
    return PassthroughSubject<[Entity], Error>().eraseToAnyPublisher()
  }
  
  func fetchSingle(with dataRequest: SingleDataRequestType?) -> AnyPublisher<Entity, Error> {
    return PassthroughSubject<Entity, Error>().eraseToAnyPublisher()
  }
  
  func reconcileAccountsFromSalesforce(remoteAccounts: [Account], salesforceAccounts: [Account]) {
    salesforceAccounts.forEach { account in
      if let matchingLocalAccount = remoteAccounts.first(where: { $0.salesforceID == account.salesforceID }) {
        account.mergeLocalProperties(with: matchingLocalAccount)
      }
    }
  }}
