//
//  ContactDataInterface.swift
//  Whaler
//
//  Created by Zachary Rhodes on 1/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class ContactDataInterface: DataInterface {
  typealias Entity = Contact
  
  typealias AllDataRequestType = ContactAllDataRequest
  typealias SubsetDataRequestType = Void
  typealias SingleDataRequestType = Void
  
  typealias DataSaveType = [Contact]
  
  private var remoteDataSource: ContactRemoteDataSource
  private var sfDataSource: ContactSFDataSource
  private var cancellable: AnyCancellable?
  private var saveCancellable: AnyCancellable?
  
  init(remoteDataSource: ContactRemoteDataSource,
       sfDataSource: ContactSFDataSource) {
    self.remoteDataSource = remoteDataSource
    self.sfDataSource = sfDataSource
  }
  
  func fetchAll(with dataRequest: AllDataRequestType?) -> AnyPublisher<[Entity], RepoError> {
    guard let dataRequest = dataRequest else {
      let message = "Fetching all contacts requires a non-nil data request"
      let error = RepoError(reason: message, humanReadableMessage: nil)
      return Fail(error: error).eraseToAnyPublisher()
    }
    
    let subject = PassthroughSubject<[Entity], RepoError>()
    
    cancellable = remoteDataSource
      .fetchAll(with: dataRequest)
      .zip(sfDataSource.fetchAll(with: dataRequest))
      .sink { (status) in
        switch status {
        case .finished:
          break
        case .failure(_):
          subject.send(completion: status)
        }
      } receiveValue: { [weak self] (remoteContacts, sfContacts) in
        self?.reconcileContactsFromSalesforce(remoteContacts: remoteContacts,
                                              salesforceContacts: sfContacts)
        subject.send(sfContacts)
        guard let strongSelf = self else { return }
        strongSelf.saveCancellable = strongSelf.remoteDataSource.saveAll(sfContacts)
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
    return remoteDataSource.saveAll(data)
  }
  
  private func reconcileContactsFromSalesforce(remoteContacts: [Contact], salesforceContacts: [Contact]) {
    //TODO optimize with hash map
    salesforceContacts.forEach { contact in
      if let matchingLocalContact = remoteContacts.first(where: { $0.salesforceID == contact.salesforceID }) {
        contact.mergeLocalProperties(with: matchingLocalContact)
      }
    }
  }
}
