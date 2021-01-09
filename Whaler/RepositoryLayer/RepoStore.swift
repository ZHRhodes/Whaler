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
  lazy var accountRepository = Repository<AccountDataInterface>(dataInterface:
                                                AccountDataInterface(
                                                  remoteDataSource: AccountRemoteDataSource(),
                                                                                   
                                                  sfDataSource: AccountSFDataSource()))
  lazy var contactRepository = Repository<ContactDataInterface>(dataInterface:
                                                                          ContactDataInterface(
                                                                            remoteDataSource: ContactRemoteDataSource(),
                                                                                                             
                                                                            sfDataSource: ContactSFDataSource()))
}
