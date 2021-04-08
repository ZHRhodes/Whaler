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
  }
}
