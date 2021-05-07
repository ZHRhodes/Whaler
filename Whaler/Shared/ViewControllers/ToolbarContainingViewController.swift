//
//  ToolbarContainingViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/9/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit
import Combine

class ToolbarContainingViewController: UIViewController {
  var backCancellable: AnyCancellable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    backCancellable = NotificationCenter.default
      .publisher(for: .back)
      .first()
      .sink(receiveValue: { [weak self] _ in
        self?.backTapped()
    })
  }
  
  func backTapped() {
    navigationController?.popViewController(animated: false)
  }
}
