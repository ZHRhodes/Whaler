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
  typealias RequestAllType = Void
  typealias RequestSingleType = String
  typealias RequestSubsetType = String
  
  private let remoteDataSource: AccountDataSource
  private let sfDataSource: AccountDataSource
  private var cancellable: AnyCancellable?
  private var saveCancellable: AnyCancellable?
  
  init(remoteDataSource: AccountDataSource,
       sfDataSource: AccountDataSource) {
    self.remoteDataSource = remoteDataSource
    self.sfDataSource = sfDataSource
  }
  
  func fetchAll(with dataRequest: RequestAllType?) -> AnyPublisher<[RepoStorable], Error> {
    let subject = PassthroughSubject<[RepoStorable], Error>()
    
    cancellable = remoteDataSource
      .fetchAll()
      .zip(sfDataSource.fetchAll())
      .sink { (status) in
      print(status)
    } receiveValue: { [weak self] (remoteAccounts, sfAccounts) in
      sfAccounts.forEach { account in
        if let matchingLocalAccount = remoteAccounts.first(where: { $0.salesforceID == account.salesforceID }) {
          account.mergeLocalProperties(with: matchingLocalAccount)
        }
      }
      subject.send(sfAccounts)
      guard let strongSelf = self else { return }
      strongSelf.saveCancellable = strongSelf.remoteDataSource.saveAll(sfAccounts)
        .sink(receiveCompletion: { _ in }, receiveValue: { subject.send($0) })
    }
    
    return subject.eraseToAnyPublisher()
  }
}
