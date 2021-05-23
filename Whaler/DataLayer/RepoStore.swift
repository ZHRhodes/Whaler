//
//  RepoStore.swift
//  Whaler
//
//  Created by Zachary Rhodes on 1/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

protocol RepoStorable {
  var id: String { get }
}

//kill on logout -- recreate
class RepoStore {
  private var ephemeralSessionManager = EphemeralSessionManager()
  
  lazy var accountRepository: Repository<AccountDataInterface> = {
    let remoteDataSource = AccountRemoteDataSource()
    let sfDataSource = AccountSFDataSource()
    let dataInterface = AccountDataInterface(remoteDataSource: remoteDataSource,
                                             sfDataSource: sfDataSource)
    return Repository(dataInterface: dataInterface, ephemeralSessionManager: ephemeralSessionManager)
  }()
  
  lazy var accountAssignmentEntryRepository: Repository<AccountAssignmentEntryDataInterface> = {
    let remoteDataSource = AccountAssignmentEntryRemoteDataSource()
    let dataInterface = AccountAssignmentEntryDataInterface(remoteDataSource: remoteDataSource)
    return Repository(dataInterface: dataInterface, ephemeralSessionManager: ephemeralSessionManager)
  }()
  
  lazy var contactRepository: Repository<ContactDataInterface> = {
    let remoteDataSource = ContactRemoteDataSource()
    let sfDataSource = ContactSFDataSource()
    let dataInterface = ContactDataInterface(remoteDataSource: remoteDataSource,
                                             sfDataSource: sfDataSource)
    return Repository(dataInterface: dataInterface, ephemeralSessionManager: ephemeralSessionManager)
  }()
  
  lazy var contactAssignmentEntryRepository: Repository<ContactAssignmentEntryDataInterface> = {
    let remoteDataSource = ContactAssignmentEntryRemoteDataSource()
    let dataInterface = ContactAssignmentEntryDataInterface(remoteDataSource: remoteDataSource)
    return Repository(dataInterface: dataInterface, ephemeralSessionManager: ephemeralSessionManager)
  }()
  
  lazy var noteRepository: Repository<NoteDataInterface> = {
    let remoteDataSource = NoteRemoteDataSource()
    let dataInterface = NoteDataInterface(remoteDataSource: remoteDataSource)
    return Repository(dataInterface: dataInterface, ephemeralSessionManager: ephemeralSessionManager)
  }()
}
