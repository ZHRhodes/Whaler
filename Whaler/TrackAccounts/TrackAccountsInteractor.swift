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
  private(set) var accounts = [Account]() {
    didSet {
      accountsTableData = accounts.map({ (account) -> TrackAccountsTableData in
        return TrackAccountsTableData(accountName: account.name,
                                      industry: account.industry,
                                      billingCity: account.billingCity,
                                      billingState: account.billingState,
                                      contactCount: String(Int.random(in: 5...35)),
                                      style: .content)
      })
    }
  }
  private(set) var accountsTableData: [TrackAccountsTableData] = []
  
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
