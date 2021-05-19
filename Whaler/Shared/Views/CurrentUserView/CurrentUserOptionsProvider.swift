//
//  CurrentUserOptionsProvider.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/22/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

struct CurrentUserOptionsProviding: SimpleItemProviding {
  func getItems(success: ([SimpleItem]) -> Void, failure: (Error) -> Void) {
    success([DisconnectSalesforceOption(), LogOutOption()])
  }
}

struct LogOutOption: SimpleItem {
  var name: String = "Log Out"
  var icon: UIImage?
}

struct DisconnectSalesforceOption: SimpleItem {
	var name: String = "Disconnect Salesforce"
	var icon: UIImage?
}
