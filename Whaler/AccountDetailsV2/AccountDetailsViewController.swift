//
//  AccountDetailsViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit
import Combine

class AccountDetailsViewController: UIViewController {
  var backSubscriber: AnyCancellable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    backSubscriber = NotificationCenter.default
      .publisher(for: .back)
      .sink(receiveValue: { [weak self] notification in
      self?.navigationController?.popViewController(animated: false) //temp, move
    })
  }
}
