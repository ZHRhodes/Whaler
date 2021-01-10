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
  lazy var accountRepository: Repository<AccountDataInterface> = {
    let remoteDataSource = AccountRemoteDataSource()
    let sfDataSource = AccountSFDataSource()
    let dataInterface = AccountDataInterface(remoteDataSource: remoteDataSource,
                                             sfDataSource: sfDataSource)
    return Repository(dataInterface: dataInterface)
  }()
  
  lazy var contactRepository: Repository<ContactDataInterface> = {
    let remoteDataSource = ContactRemoteDataSource()
    let sfDataSource = ContactSFDataSource()
    let dataInterface = ContactDataInterface(remoteDataSource: remoteDataSource,
                                             sfDataSource: sfDataSource)
    return Repository(dataInterface: dataInterface)
  }()
}
