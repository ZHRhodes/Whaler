//
//  AuthenticationViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/2/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class AuthenticationViewController: UIViewController {
  private let authView = UIHostingController(rootView: AuthenticationView())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(authView.view)
    
    authView.view.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      authView.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      authView.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      authView.view.topAnchor.constraint(equalTo: view.topAnchor),
      authView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
}
