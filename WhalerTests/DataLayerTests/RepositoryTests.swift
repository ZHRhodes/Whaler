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
  
  override func setUpWithError() throws {}

  override func tearDownWithError() throws {
    cancellable = nil
  }

  func testRepoForAccount() throws {
    let repoStore = RepoStore()
    let repo = repoStore.accountRepository
    XCTAssert(repo.type === Account.self)
  }
  
  func testBroadcastNewValues() throws {
    let repo = Repository(dataInterface: MockAccountInterface())
    let expectation = self.expectation(description: "Broadcasted values")
    
    cancellable = repo.fetchAll().sink { _ in
    } receiveValue: { (accounts) in
      guard accounts.count > 0 else { return }
      XCTAssertEqual(accounts.count, 2)
      XCTAssertEqual(accounts[0].name, "NameA")
      XCTAssertEqual(accounts[1].name, "NameB")
      expectation.fulfill()
    }
    
    repo.broadcast(newValues: accountSet2)
    
    waitForExpectations(timeout: 2.0, handler: nil)
  }
  
  func testSubscribingToCurrentValue() throws {
    let repo = Repository(dataInterface: MockAccountInterface())
    repo.fetchAll(with: accountSet1)
    let expectation = self.expectation(description: "Received values")
    cancellable = repo.publisher.sink { _ in
    } receiveValue: { (accounts) in
      XCTAssertEqual(accounts.count, 3)
      XCTAssertEqual(accounts[0].name, "Name1")
      XCTAssertEqual(accounts[1].name, "Name2")
      XCTAssertEqual(accounts[2].name, "Name3")
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 2.0, handler: nil)
  }
  
  func testFetchingAllAfterSubscription() throws {
    let repo = Repository(dataInterface: MockAccountInterface())
    let expectation = self.expectation(description: "Received values")
    cancellable = repo.publisher.sink { _ in
    } receiveValue: { (accounts) in
      guard accounts.count > 0 else { return }
      XCTAssertEqual(accounts.count, 3)
      XCTAssertEqual(accounts[0].name, "Name1")
      XCTAssertEqual(accounts[1].name, "Name2")
      XCTAssertEqual(accounts[2].name, "Name3")
      expectation.fulfill()
    }
    
    repo.fetchAll(with: accountSet1)

    waitForExpectations(timeout: 2.0, handler: nil)
  }
  
  func testFetchAllReplacesCurrentValue() throws {
    let repo = Repository(dataInterface: MockAccountInterface())
    let expectation = self.expectation(description: "Received values")
    var allFetchedOnce = false
    
    cancellable = repo.fetchAll(with: accountSet1).sink { _ in
    } receiveValue: { (accounts) in
      guard accounts.count > 0 else { return }
      
      if !allFetchedOnce {
        XCTAssertEqual(accounts.count, 3)
        XCTAssertEqual(accounts[0].name, "Name1")
        XCTAssertEqual(accounts[1].name, "Name2")
        XCTAssertEqual(accounts[2].name, "Name3")
        allFetchedOnce = true
        return
      }

      XCTAssertEqual(accounts.count, 2)
      XCTAssertEqual(accounts[0].name, "NameA")
      XCTAssertEqual(accounts[1].name, "NameB")
      
      expectation.fulfill()
    }
   
    repo.fetchAll(with: accountSet2)
    
    waitForExpectations(timeout: 2.0, handler: nil)
  }
  
  func testFetchSubsetReturnsSubsetPublisher() throws {
    let repo = Repository(dataInterface: MockAccountInterface())
    let expectation = self.expectation(description: "Received subset")
    cancellable = repo.fetchSubset(with: accountSet2).sink(receiveCompletion: { _ in }, receiveValue: { (accounts) in
      XCTAssertEqual(accounts.count, 2)
      XCTAssertEqual(accounts[0].name, "NameA")
      XCTAssertEqual(accounts[1].name, "NameB")
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 2.0, handler: nil)
  }
  
  func testFetchSubsetUpdatesCurrentValue() throws {
    let repo = Repository(dataInterface: MockAccountInterface())
    let expectation = self.expectation(description: "Received subset")
    var allFetched = false
    
    cancellable = repo.fetchAll(with: accountSet1).sink(receiveCompletion: { _ in }, receiveValue: { (accounts) in
      if !allFetched {
        allFetched = true
        return
      }
      XCTAssertEqual(accounts.count, 3)
      XCTAssertEqual(accounts[0].name, "NameA")
      XCTAssertEqual(accounts[1].name, "NameB")
      XCTAssertEqual(accounts[2].name, "Name3")
      expectation.fulfill()
    })
    
    _ = repo.fetchSubset(with: accountSet2)
    
    waitForExpectations(timeout: 2.0, handler: nil)
  }
  
  func testFetchSingleReturnsSinglePublisher() throws {
    let repo = Repository(dataInterface: MockAccountInterface())
    let expectation = self.expectation(description: "Received single")
    cancellable = repo.fetchSingle(with: account1).sink(receiveCompletion: { _ in }, receiveValue: { (account) in
      XCTAssertEqual(account.name, "Name1")
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 2.0, handler: nil)
  }
  
  func testFetchSingleUpdatesCurrentValue() throws {
    let repo = Repository(dataInterface: MockAccountInterface())
    let expectation = self.expectation(description: "Received single")
    var allFetched = false
    
    cancellable = repo.fetchAll(with: accountSet1).sink(receiveCompletion: { _ in }, receiveValue: { (accounts) in
      if !allFetched {
        allFetched = true
        return
      }
      XCTAssertEqual(accounts.count, 3)
      XCTAssertEqual(accounts[0].name, "Name1")
      XCTAssertEqual(accounts[1].name, "NameB")
      XCTAssertEqual(accounts[2].name, "Name3")
      expectation.fulfill()
    })
    
    _ = repo.fetchSingle(with: accountB)
    
    waitForExpectations(timeout: 2.0, handler: nil)
  }
  
  func testSaveReturnsSavedDataPublisher() throws {
    let repo = Repository(dataInterface: MockAccountInterface())
    let expectation = self.expectation(description: "Saved data")
    repo.fetchAll(with: accountSet1)
    cancellable = repo.save(accountSet2).sink(receiveCompletion: { _ in }, receiveValue: { (accounts) in
      XCTAssertEqual(accounts.count, 2)
      XCTAssertEqual(accounts[0].name, "NameA")
      XCTAssertEqual(accounts[1].name, "NameB")
      expectation.fulfill()
    })
    
    waitForExpectations(timeout: 2.0, handler: nil)
  }
  
  func testSaveUpdatesCurrentValue() throws {
    let repo = Repository(dataInterface: MockAccountInterface())
    let expectation = self.expectation(description: "Saved data")
    var allFetched = false
    
    cancellable = repo.fetchAll(with: accountSet1).sink(receiveCompletion: { _ in }, receiveValue: { (accounts) in
      if !allFetched {
        allFetched = true
        return
      }
      XCTAssertEqual(accounts.count, 3)
      XCTAssertEqual(accounts[0].name, "NameA")
      XCTAssertEqual(accounts[1].name, "NameB")
      XCTAssertEqual(accounts[2].name, "Name3")
      expectation.fulfill()
    })
    
    _ = repo.save(accountSet2)
    
    waitForExpectations(timeout: 2.0, handler: nil)
  }
}

extension RepositoryTests {
  private var account1: Account {
    let account = Account()
    account.id = "1"
    account.name = "Name1"
    return account
  }
  
  private var account2: Account {
    let account = Account()
    account.id = "2"
    account.name = "Name2"
    return account
  }
  
  private var account3: Account {
    let account = Account()
    account.id = "3"
    account.name = "Name3"
    return account
  }
  
  private var accountSet1: [Account] {
    return [account1, account2, account3]
  }
  
  private var accountA: Account {
    let account = Account()
    account.id = "1"
    account.name = "NameA"
    return account
  }
  
  private var accountB: Account {
    let account = Account()
    account.id = "2"
    account.name = "NameB"
    return account
  }
  
  private var accountSet2: [Account] {
    return [accountA, accountB]
  }
}
