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
  var backCancellable: AnyCancellable?
  private let splitPaneViewController = SplitPaneViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSplitPaneViewController()
    backCancellable = NotificationCenter.default
      .publisher(for: .back)
      .sink(receiveValue: { [weak self] notification in
      self?.navigationController?.popViewController(animated: false) //temp, move
    })
  }
  
  private func configureSplitPaneViewController() {
    splitPaneViewController.resizable = true
    
    let vc1 = UIViewController()
    vc1.view.backgroundColor = .white
    splitPaneViewController.appendViewController(vc1)
    
    let vc2 = UIViewController()
    vc2.view.backgroundColor = .white
    splitPaneViewController.appendViewController(vc2)
    
    try? splitPaneViewController.setDistribution(ratios: [0.60, 0.40])
    view.addAndAttachToEdges(view: splitPaneViewController.view)
  }
}
