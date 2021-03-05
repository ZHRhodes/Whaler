//
//  AccountDetailsInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/4/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct AccountDetailsInteractor {
  let dataManager: MainDataManager
  
  var account: Account? {
    if let lastSelected = dataManager.lastSelected {
      return dataManager.accountGrouper[lastSelected.state][lastSelected.index]
    } else {
      Log.error("Arrived at account details without lastSelected.")
      return nil
    }
  }
  
  func save(account: Account?, withNoteText text: String) {
    guard let account = account else { return }
    account.notes = text
    _ = repoStore.accountRepository.save([account])
  }
}
