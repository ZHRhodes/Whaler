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
  weak var viewController: TrackAccountsViewController?
  var trackingChanges = [String: TrackingChange<Account>]()
  var appliedFilters = Set<Filter>()
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
  
  func account(atRow row: Int, onPage page: Int) -> Account {
    let index = page * pageSize + row
    return accounts[index]
  }
  
  func fetchAccounts() {
    fetchCancellable = repoStore
      .accountRepository
      .fetchSubset(with: appliedFilters)
      .sink(receiveCompletion: { _ in }) { [weak self] (accounts) in
        self?.accounts = accounts
        self?.viewController?.didFetchAccounts()
    }
  }
  
  func applyTrackingChanges() {
    //temp, move
    let input: [AccountTrackingChange] = trackingChanges.values.map { (trackingChange) in
      return AccountTrackingChange(account: makeNewAccount(from: trackingChange.value),
                                   newState: trackingChange.newTrackingState.rawValue)
    }

    Graph.shared.apollo.perform(mutation: ApplyAccountTrackingChangesMutation(input: input)) { result in
      let resultGet = try? result.get()
      print(resultGet?.errors)
      guard let data = try? result.get().data else { return }
      print(data.success)
    }
  }
  
  private func makeNewAccount(from account: Account) -> NewAccount {
    return NewAccount(id: account.id,
                      salesforceId: account.salesforceID,
                      name: account.name,
                      industry: account.industry,
                      description: account.accountDescription,
                      numberOfEmployees: account.numberOfEmployees,
                      annualRevenue: account.annualRevenue,
                      billingCity: account.billingCity,
                      billingState: account.billingState,
                      phone: account.phone,
                      website: account.website,
                      type: account.type,
                      state: account.state?.rawValue,
                      notes: account.notes)
  }
}
