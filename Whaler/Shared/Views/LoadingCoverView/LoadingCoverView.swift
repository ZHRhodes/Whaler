//
//  LoadingCoverView.swift
//  Whaler
//
//  Created by Zack Rhodes on 5/31/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class LoadingCoverView: UIView {
	var progressView: ProgressView!
	
	init() {
		super.init(frame: .zero)
		configureProgressIndicator()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configureProgressIndicator() {
		progressView = ProgressView.makeDefaultStyle()
		addAndAttach(view: progressView,
								 height: 75,
								 width: 75,
								 attachingEdges: [.center()])
		progressView.isAnimating = true
	}
}
