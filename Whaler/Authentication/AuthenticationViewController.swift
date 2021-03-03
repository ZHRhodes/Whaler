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
  static let minSize: CGSize = CGSize(width: 2136, height: 1217)
  static let maxSize: CGSize = minSize
  
  private let interactor = AuthenticationInteractor(networkInterface: APINetworkInterface())
  weak var delegate: AuthenticationViewControllerDelegate?
  
  private let authViewModel = AuthenticationView.ViewModel()
  private lazy var authView = UIHostingController(rootView: AuthenticationView(delegate: self, textFieldDelegate: self, viewModel: authViewModel))
  private var incomingToolbar: NSToolbar?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(authView.view)
    view.backgroundColor = .primaryBackground
    authView.view.translatesAutoresizingMaskIntoConstraints = false
    
    let constraints = [
      authView.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      authView.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      authView.view.topAnchor.constraint(equalTo: view.topAnchor),
      authView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
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
