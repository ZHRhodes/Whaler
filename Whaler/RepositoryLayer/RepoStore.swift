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

class RepoStore {
  var accountRepository = Repository<Account>(dataInterface:
                                                AccountDataInterface(
                                                  remoteDataSource: AccountRemoteDataSource(),
                                                                                   
                                                  sfDataSource: AccountSFDataSource()))
}
