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
  
  func fetchAccounts() {
    fetchCancellable = repoStore
      .accountRepository
      .fetchAll()
      .sink(receiveCompletion: { _ in }) { [weak self] (accounts) in
        self?.accounts = accounts
        self?.viewController?.didFetchAccounts()
    }
  }
}
