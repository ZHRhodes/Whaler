//
//  AccountDetailsContentInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine

class AccountDetailsContentInteractor {
  let dataManager: MainDataManager
	var widgets = [AccountWidget]()

  var account: Account {
    if let lastSelected = dataManager.lastSelected {
      return dataManager.accountGrouper[lastSelected.state][lastSelected.index]
    } else {
      Log.error("Arrived at account details without lastSelected.")
      return Account()
    }
  }
	
	init(dataManager: MainDataManager) {
		self.dataManager = dataManager
		let accountSource = Just<Account>(account).eraseToAnyPublisher()
		widgets = [.details(DefaultDetailsProvider(source: accountSource)), .contacts(DefaultContactsProvider())]
	}
}
