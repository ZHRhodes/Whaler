//
//  AccountRepoTests.swift
//  WhalerTests
//
//  Created by Zachary Rhodes on 6/21/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import XCTest
@testable import Whaler

class AccountRepoTests: XCTestCase {
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
     
    }

    func testRepoForAccount() throws {
      let repo = Repo.for(Account.self, using: RepoStore())
      XCTAssert(repo is AccountRepository)
    }
}
