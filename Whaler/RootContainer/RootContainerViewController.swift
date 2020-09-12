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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewsOnLaunch()
    unauthorizedUserCancellable = interactor.unauthorizedUserPublisher.sink { [weak self] _ in
      self?.showAuthenticationView()
    }
  }
  
  private func configureViewsOnLaunch() {
    Lifecycle.loadApiTokens()
    if !Lifecycle.hasTokens() {
      showAuthenticationView()
      return
    } else {
      showMainView()
      Lifecycle.refreshAPITokens { [weak self] (success) in
        if !success {
          self?.removeMainView()
          self?.showAuthenticationView()
        } else {
          self?.showMainView()
        }
      }
    }
  }
  
  private func showAuthenticationView() {
    authenticationViewController?.view.removeFromSuperview()
    authenticationViewController = AuthenticationViewController()
    authenticationViewController!.delegate = self
    
    guard let authView = authenticationViewController?.view else { return }
    view.addSubview(authView)
    
    authView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      authView.leftAnchor.constraint(equalTo: view.leftAnchor),
      authView.rightAnchor.constraint(equalTo: view.rightAnchor),
      authView.topAnchor.constraint(equalTo: view.topAnchor),
      authView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ]
    
    NSLayoutConstraint.activate(constraints)
    
    UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
      windowScene.sizeRestrictions?.minimumSize = AuthenticationViewController.minSize
      windowScene.sizeRestrictions?.maximumSize = AuthenticationViewController.maxSize
    }
  }
  
  private func showMainView() {
    mainViewController?.removeFromParent()
    mainViewController?.view.removeFromSuperview()
    mainViewController = MainViewController()
    let navigationController = UINavigationController(rootViewController: mainViewController!)
    navigationController.navigationBar.isHidden = true
    navigationController.modalPresentationStyle = .fullScreen
    
    present(navigationController, animated: false, completion: nil)
    
//    guard let mainView = mainViewController.view else { return }
//    view.addSubview(mainView)
//
//    mainView.translatesAutoresizingMaskIntoConstraints = false
//    let constraints = [
//      mainView.leftAnchor.constraint(equalTo: view.leftAnchor),
//      mainView.rightAnchor.constraint(equalTo: view.rightAnchor),
//      mainView.topAnchor.constraint(equalTo: view.topAnchor),
//      mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//    ]
//
//    NSLayoutConstraint.activate(constraints)
    
    UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
      windowScene.sizeRestrictions?.minimumSize = MainViewController.minSize
      windowScene.sizeRestrictions?.maximumSize = MainViewController.maxSize
    }
  }
  
  private func removeAuthenticationView() {
    authenticationViewController?.view.removeFromSuperview()
    authenticationViewController = nil
  }
  
  private func removeMainView() {
    mainViewController?.view.removeFromSuperview()
    mainViewController = nil
  }
}

extension RootContainerViewController: AuthenticationViewControllerDelegate {
  func signedIn() {
    removeAuthenticationView()
    showMainView()
  }
}
