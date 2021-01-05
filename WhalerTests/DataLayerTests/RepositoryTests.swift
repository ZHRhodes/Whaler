//
//  RepositoryTests.swift
//  WhalerTests
//
//  Created by Zachary Rhodes on 6/21/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import XCTest
import Combine
@testable import Whaler

class RepositoryTests: XCTestCase {
  var cancellable: AnyCancellable?
  
  override func setUpWithError() throws {
      
  }

  override func tearDownWithError() throws {
    cancellable = nil
  }

  func testRepoForAccount() throws {
    let repoStore = RepoStore()
    let repo = repoStore.accountRepository
    XCTAssert(repo.type === Account.self)
  }
  
  func testSubscribingToCurrentValue() throws {
    var repo = Repository<Account>(dataInterface: MockAccountInterface())
    repo.fetchAll()
    let expectation = self.expectation(description: "Received values")
    cancellable = repo.publisher.sink { _ in
    } receiveValue: { (accounts) in
      XCTAssertEqual(accounts.count, 2)
      XCTAssertEqual(accounts[0].id, "123")
      XCTAssertEqual(accounts[1].id, "456")
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 2.0, handler: nil)
  }
  
  func testFetchingAfterSubscription() throws {
    var repo = Repository<Account>(dataInterface: MockAccountInterface())
    let expectation = self.expectation(description: "Received values")
    cancellable = repo.publisher.sink { _ in
    } receiveValue: { (accounts) in
      guard accounts.count > 0 else { return }
      XCTAssertEqual(accounts.count, 2)
      XCTAssertEqual(accounts[0].id, "123")
      XCTAssertEqual(accounts[1].id, "456")
      expectation.fulfill()
    }
    
    repo.fetchAll()

    waitForExpectations(timeout: 2.0, handler: nil)
  }
}

class MockAccountInterface: DataInterface {
  func fetchAll() -> AnyPublisher<[RepoStorable], Error> {
    let account1 = Account()
    account1.id = "123"
    let account2 = Account()
    account2.id = "456"
    return Future<[RepoStorable], Error> { promise in
      promise(.success([account1, account2]))
    }.eraseToAnyPublisher()
  }
}

