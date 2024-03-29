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
  private var unauthorizedUserCancellable: AnyCancellable?
	private var disconnectSalesforeCancellable: AnyCancellable?
  
  private var state: State?
  private var shownViewController: UIViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .primaryBackground
    configureViewsOnLaunch()
    unauthorizedUserCancellable = interactor.unauthorizedUserPublisher.sink { [weak self] _ in
      Lifecycle.logOut(tokenContainers: [Lifecycle.self])
      self?.transition(to: .authentication)
    }
		disconnectSalesforeCancellable = interactor.disconnectSalesforcePublisher.sink(receiveValue: { _ in
			Lifecycle.logOut(using: nil, tokenContainers: [SFSession.self])
		})
  }
  
  func transition(to newState: State) {
    shownViewController?.remove()
    let vc = viewController(for: newState)
    add(vc)
    shownViewController = vc
    setWindowConstraints(for: newState)
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
      let vc = AuthenticationViewController()
      vc.delegate = self
      return vc
    case .main:
      let navigationController = UINavigationController(rootViewController: MainViewController())
      navigationController.isNavigationBarHidden = true
      return navigationController
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
