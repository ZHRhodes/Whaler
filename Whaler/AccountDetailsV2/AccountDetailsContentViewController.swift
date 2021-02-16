//
//  AccountDetailsContentViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/15/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class AccountDetailsContentViewController: UIViewController {
  private var interactor: MainInteractor!
  private let contactsVC = AccountDetailsContactsViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func configure(with interactor: MainInteractor) {
    self.interactor = interactor
    configureContactsSection()
  }
  
  func configureContactsSection() {
    contactsVC.configure(with: interactor)
    contactsVC.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contactsVC.view)
    contactsVC.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    contactsVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65).isActive = true
    contactsVC.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    contactsVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
  }
}
