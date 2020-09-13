//
//  RootContainerViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/2/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Combine
import UIKit

class RootContainerViewController: UIViewController {
  private var mainViewController: MainViewController?
  private var authenticationViewController: AuthenticationViewController?
  
  private let interactor = RootContainerInteractor()
  private var unauthorizedUserCancellable: Cancellable!
  
  private var state: State?
  private var shownViewController: UIViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewsOnLaunch()
    unauthorizedUserCancellable = interactor.unauthorizedUserPublisher.sink { [weak self] _ in
      self?.transition(to: .authentication)
    }
  }
  
  func transition(to newState: State) {
    shownViewController?.remove()
    let vc = viewController(for: newState)
    add(vc)
    shownViewController = vc
    state = newState
  }
  
  func setWindowConstraints(for state: State) {
    let minSize: CGSize
    let maxSize: CGSize
    
    switch state {
    case .authentication:
      minSize = AuthenticationViewController.minSize
      maxSize = AuthenticationViewController.maxSize
    case .main:
      minSize = MainViewController.minSize
      maxSize = MainViewController.maxSize
    }
    
    UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
      windowScene.sizeRestrictions?.minimumSize = minSize
      windowScene.sizeRestrictions?.maximumSize = maxSize
    }
  }
  
  func viewController(for state: State) -> UIViewController {
    switch state {
    case .authentication:
      return AuthenticationViewController()
    case .main:
      return MainViewController()
    }
  }
  
  private func configureViewsOnLaunch() {
    Lifecycle.loadApiTokens()
    if !Lifecycle.hasTokens() {
      transition(to: .authentication)
      return
    } else {
      transition(to: .main)
      Lifecycle.refreshAPITokens { [weak self] (success) in
        if !success {
          self?.transition(to: .authentication)
        } else {
          self?.transition(to: .main)
        }
      }
    }
  }
}

extension RootContainerViewController: AuthenticationViewControllerDelegate {
  func signedIn() {
    transition(to: .main)
  }
}

extension RootContainerViewController {
  enum State {
    case authentication
    case main
  }
}
