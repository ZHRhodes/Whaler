//
//  UpdaterInteractor.swift
//  Whaler
//
//  Created by Zack Rhodes on 6/3/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import SparkleBridgeClient

class UpdaterInteractor {
	let driver: CatalystSparkleDriver
	var plugin: SparkleBridgePlugin?
	
	init(driver: CatalystSparkleDriver) {
		self.driver = driver
		let result = SparkleBridgeClient.load(with: driver)
		switch result {
		case .success(let plugin):
			self.plugin = plugin
		case .failure(let error):
			Log.error(String(describing: error))
		}
	}
}
