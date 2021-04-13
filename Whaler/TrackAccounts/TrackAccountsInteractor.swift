//
//  TrackAccountsInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class TrackAccountsInteractor {
  private var fetchCancellable: AnyCancellable?
  private var applyCancellable: AnyCancellable?
  weak var viewController: TrackAccountsViewController?
  private let currentlyTrackingIds: Set<String>
  var trackingChanges = [String: TrackingChange<Account>]()
  var appliedFilters = Set<Filter>()
  var currentTrackingRange: Range<Int> = 0..<0
  var pageSize: Int = 12
  private(set) var numberOfPages = 0 {
    didSet {
      viewController?.setNumberOfPages(numberOfPages)
    }
  }
  private(set) var accounts = [Account]() {
    didSet {
      accountsTableData = [:]
      var page = 1
      var numInCurrentPage = 0
      for account in accounts {
        let accountData =  TrackAccountsTableData(accountName: account.name,
                                                  industry: account.industry,
                                                  billingCity: account.billingCity,
                                                  billingState: account.billingState,
                                                  contactCount: String(Int.random(in: 5...35)),
                                                  style: .content)
        if accountsTableData[page] == nil {
          accountsTableData[page] = []
        }
        accountsTableData[page]?.append(accountData)
        numInCurrentPage += 1
        if numInCurrentPage == pageSize {
          page += 1
          numInCurrentPage = 0
        }
      }
      if numInCurrentPage == 0 {
        page = page - 1
      }
      numberOfPages = page
    }
  }
  private(set) var accountsTableData: [Int: [TrackAccountsTableData]] = [:]
  
  init(currentlyTracking: Set<Account>) {
    self.currentlyTrackingIds = Set(currentlyTracking.map { $0.salesforceID ?? ""})
  }
  
  func applySelfOwnFilter() {
    OwnerOptionsProvider().fetchOptions { [weak self] (options) in
      let selfOption = options.first { (displayOption) -> Bool in
        switch displayOption.filter {
        case .owner(let owner):
          return owner.id == SFSession.id
        default:
          return false
        }
      }
      
      guard let option = selfOption else { return }
      self?.viewController?.selected(filterDisplayOption: option)
    }
  }
  
  func account(atRow row: Int, onVisiblePage page: Int) -> Account {
    let index = convertVisibleRowToAccountIndex(row: row, visiblePage: page)
    return accounts[index]
  }
  
  func isTrackingAccount(atRow row: Int, onVisiblePage page: Int) -> Bool {
    let index = convertVisibleRowToAccountIndex(row: row, visiblePage: page)
    return currentTrackingRange.contains(index)
  }
  
  private func convertVisibleRowToAccountIndex(row: Int, visiblePage: Int) -> Int {
    return (visiblePage - 1) * pageSize + row
  }
  
  func fetchAccounts() {
    fetchCancellable = repoStore
      .accountRepository
      .ephemeral
      .fetchSubset(with: appliedFilters)
      .sink(receiveCompletion: { _ in }) { [weak self] (accounts) in
        self?.processFetchedAccounts(accounts)
        self?.viewController?.didFetchAccounts()
    }
  }
  
  private func processFetchedAccounts(_ fetchedAccounts: [Account]) {
    var trackedAccounts = [Account]()
    var untrackedAccounts = [Account]()
    
    fetchedAccounts.forEach { (account) in
      if currentlyTrackingIds.contains(account.salesforceID ?? "") {
        trackedAccounts.append(account)
      } else {
        untrackedAccounts.append(account)
      }
    }
    
    currentTrackingRange = 0..<trackedAccounts.count
    self.accounts = trackedAccounts + untrackedAccounts
  }
  
  func applyTrackingChanges(completion: @escaping () -> Void) {
    let changes = trackingChanges.values.map { $0 }
    applyCancellable = repoStore
      .accountRepository
      .save(.trackingChange(changes), updatePolicy: .all)
      .sink(receiveCompletion: { _ in }) { (_) in
        completion()
    }
  }
}
