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
  
  private let interactor = AuthenticationInteractor(networkInterface: APINetworkInterface())
  weak var delegate: AuthenticationViewControllerDelegate?
  
  private let authViewModel = AuthenticationView.ViewModel()
  private lazy var authView = UIHostingController(rootView: AuthenticationView(delegate: self, textFieldDelegate: self, viewModel: authViewModel))
  
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
    interactor.signIn(email: email, password: password) { [weak self] in
      self?.delegate?.signedIn()
    } failure: {
      //show error
    }
  }
}

extension AuthenticationViewController: TextFieldDelegate {
  func didPressEnter(from textField: UITextField) {
    signInTapped(email: authViewModel.email, password: authViewModel.password)
  }
}
