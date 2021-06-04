//
//  ToolbarHidingViewController.swift
//  Whaler
//
//  Created by Zack Rhodes on 6/3/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class ToolbarHidingViewController: UIViewController {
	private var incomingToolbar: NSToolbar?
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let windowScene = view.window?.windowScene
		windowScene?.titlebar?.titleVisibility = .hidden
		incomingToolbar = windowScene?.titlebar?.toolbar
		windowScene?.titlebar?.toolbar = nil
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		let windowScene = view.window?.windowScene
		windowScene?.titlebar?.titleVisibility = .visible
		windowScene?.titlebar?.toolbar = incomingToolbar
	}
}
