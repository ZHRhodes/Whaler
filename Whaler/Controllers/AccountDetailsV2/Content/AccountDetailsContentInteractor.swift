//
//  AccountDetailsContentInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine
import Starscream

class AccountDetailsContentInteractor {
  let dataManager: MainDataManager
  var socket: WebSocketClient?
	var widgets = [AccountWidget]()

  var account: Account {
    if let lastSelected = dataManager.lastSelected {
      return dataManager.accountGrouper[lastSelected.state][lastSelected.index]
    } else {
      Log.error("Arrived at account details without lastSelected.")
      return Account()
    }
  }
	
  init(dataManager: MainDataManager, socket: WebSocketClient?) {
		self.dataManager = dataManager
    self.socket = socket
		let accountSource = Just<Account>(account).eraseToAnyPublisher()
		widgets = [.details(DefaultDetailsProvider(source: accountSource)),
               .tasks(DefaultTasksProvider()),
               .contacts(DefaultContactsProvider())]
	}
}
