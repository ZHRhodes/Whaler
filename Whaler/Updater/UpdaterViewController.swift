//
//  UpdaterViewController.swift
//  Whaler
//
//  Created by Zack Rhodes on 6/3/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit
import SparkleBridgeClient

class UpdaterViewController: ToolbarHidingViewController {
	static let minSize: CGSize = CGSize(width: 700, height: 400)
	static let maxSize: CGSize = minSize
	
	var interactor: UpdaterInteractor!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let label = UILabel()
		label.text = interactor.driver.status
		view.addAndAttach(view: label,
											height: 200,
											width: 200,
											attachingEdges: .center())
	}
}
