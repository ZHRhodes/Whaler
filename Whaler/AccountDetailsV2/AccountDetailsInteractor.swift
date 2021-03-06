//
//  AccountDetailsInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/4/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class AccountDetailsInteractor {
  let dataManager: MainDataManager
  weak var viewController: AccountDetailsViewController?
  private let noteChangePublisher = PassthroughSubject<String, Never>()
  private var noteChangeCancellable: AnyCancellable?
  private var noteSaveCancellable: AnyCancellable?
  
  var account: Account? {
    if let lastSelected = dataManager.lastSelected {
      return dataManager.accountGrouper[lastSelected.state][lastSelected.index]
    } else {
      Log.error("Arrived at account details without lastSelected.")
      return nil
    }
  }
  
  init(dataManager: MainDataManager) {
    self.dataManager = dataManager
    noteChangeCancellable = noteChangePublisher
      .debounce(for: .seconds(0.75), scheduler: DispatchQueue.main)
      .sink { [weak self] (newValue) in
        guard let strongSelf = self else { return }
        strongSelf.viewController?.didBeginSaving()
        strongSelf.save(account: strongSelf.account, withNoteText: newValue)
    }
  }
  
  func save(account: Account?, withNoteText text: String) {
    guard let account = account else { return }
    account.notes = text
    noteSaveCancellable = repoStore
      .accountRepository
      .save([account]).sink(receiveCompletion: { _ in },
                            receiveValue: { [weak self] (accounts) in
      self?.viewController?.didFinishSaving()
    })
  }
  
  func changedNoteText(newValue: String) {
    noteChangePublisher.send(newValue)
  }
}
