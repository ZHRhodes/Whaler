//
//  AccountDetailsContentInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

struct AccountDetailsContentInteractor {
  let dataManager: MainDataManager

  var account: Account {
    if let lastSelected = dataManager.lastSelected {
      return dataManager.accountGrouper[lastSelected.state][lastSelected.index]
    } else {
      Log.error("Arrived at account details without lastSelected.")
      return Account()
    }
  }
}
