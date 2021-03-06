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
  private let noteChangePublisher = PassthroughSubject<String, Never>()
  private var noteChangeCancellable: AnyCancellable?
  
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
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global())
      .sink { [weak self] (newValue) in
        guard let strongSelf = self else { return }
        strongSelf.save(account: strongSelf.account, withNoteText: newValue)
    }
  }
  
  func save(account: Account?, withNoteText text: String) {
    guard let account = account else { return }
    account.notes = text
    _ = repoStore.accountRepository.save([account])
  }
  
  func changedNoteText(newValue: String) {
    noteChangePublisher.send(newValue)
  }
}
