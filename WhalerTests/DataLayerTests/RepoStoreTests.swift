//
//  RepoStoreTests.swift
//  WhalerTests
//
//  Created by Zachary Rhodes on 1/4/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import XCTest
import Combine
@testable import Whaler

class RepoStoreTests: XCTestCase {
  func testRepoForAccount() throws {
    let repoStore = RepoStore()
    let repo = repoStore.accountRepository
    XCTAssert(repo.type === Account.self)
  }
  
  func testRepoForContact() throws {
    let repoStore = RepoStore()
    let repo = repoStore.contactRepository
    XCTAssert(repo.type === Contact.self)
  }
}
