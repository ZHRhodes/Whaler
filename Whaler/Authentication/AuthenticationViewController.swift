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

protocol AuthenticationViewControllerDelegate: class {
  func signedIn()
}

class AuthenticationViewController: UIViewController {
  static let minSize: CGSize = CGSize(width: 1400, height: 1000)
  static let maxSize: CGSize = minSize
  
  weak var delegate: AuthenticationViewControllerDelegate?
  
  private lazy var authView = UIHostingController(rootView: AuthenticationView(delegate: self))
  
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

extension AuthenticationViewController: AuthenticationViewDelegate {
  func signInTapped(email: String, password: String) {
    delegate?.signedIn()
  }
}
