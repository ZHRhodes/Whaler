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

protocol AuthenticationViewControllerDelegate: AnyObject {
  func signedIn()
}

class AuthenticationViewController: ToolbarHidingViewController {
  static let minSize: CGSize = CGSize(width: 1440, height: 900)
  static let maxSize: CGSize = minSize
  
  private let interactor = AuthenticationInteractor(networkInterface: APINetworkInterface())
  weak var delegate: AuthenticationViewControllerDelegate?
  
  private let authViewModel = AuthenticationView.ViewModel()
  private lazy var authView = UIHostingController(rootView: AuthenticationView(delegate: self, textFieldDelegate: self, viewModel: authViewModel))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(authView.view)
    view.backgroundColor = .primaryBackground
		view.addAndAttach(view: authView.view, attachingEdges: .all())
	}
}

extension AuthenticationViewController: AuthenticationViewDelegate {
  func signInTapped(email: String, password: String) {
    interactor.signIn(email: email, password: password) { [weak self] in
      self?.delegate?.signedIn()
    } failure: { [weak self] message in
      self?.authViewModel.errorMessage = message
    }
  }
}

extension AuthenticationViewController: TextFieldDelegate {
  func didPressEnter(from textField: UITextField) {
    signInTapped(email: authViewModel.email, password: authViewModel.password)
  }
}
