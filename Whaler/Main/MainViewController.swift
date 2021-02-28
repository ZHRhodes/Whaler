//
//  MainViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/21/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AuthenticationServices
import SkeletonView

class WeakRef<T> where T: AnyObject {
  private(set) weak var value: T?

  init(value: T?) {
      self.value = value
  }
}

extension WeakRef: Hashable {
  static func == (lhs: WeakRef<T>, rhs: WeakRef<T>) -> Bool {
    return lhs === rhs
  }
  
  func hash(into hasher: inout Hasher) {
    guard let value = value else { return }
    hasher.combine(Unmanaged.passUnretained(value).toOpaque())
  }
}

struct MainViewControllerRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = AuthenticationViewController
  
  func makeUIViewController(context: Context) -> AuthenticationViewController {
    return AuthenticationViewController()
  }
  
  func updateUIViewController(_ uiViewController: AuthenticationViewController, context: Context) {
    
  }
}

class MainViewController: UIViewController {
  static let minSize = CGSize(width: 2155, height: 1217)
  static let maxSize = CGSize(width: 2155, height: 1217)
  
  private var interactor: MainInteractor!
  private var noDataStackView: UIStackView?
  private var reloadButton: UIButton!
  private var deleteButton: UIButton!
  private var signOutButton: UIButton!
  private var helloLabel: UILabel!
  private var subHelloLabel: UILabel!
  private var collectionView: UICollectionView!
  
  private var sectionHeaders = Set<WeakRef<UIView>>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Accounts"
    view.backgroundColor = .primaryBackground
    SkeletonAppearance.default.multilineHeight = 30.0
    
    Lifecycle.loadCurrentUser()
    interactor = MainInteractor()
    interactor.viewController = self
    
    if interactor.hasSalesforceTokens {
      //present loading indicator
      interactor.refreshSalesforceSession { [weak self] (success) in
        if success {
          self?.interactor.getAccounts()
          self?.configureViewsForContent()
        } else {
          if !(self?.interactor.hasAccounts() ?? false) {
            self?.configureNoDataViews()
          }
        }
      }
    } else {
      configureNoDataViews()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    collectionView?.reloadData()
  }
  
  private func configureViewsForContent() {
    removeNoDataViews()
    configureHelloLabel()
    configureSubHelloLabel()
    configureCollectionView()
    configureSignOutButton()
    configureDeleteButton()
    configureReloadButton()
  }
  
  private func configureNoDataViews() {
    noDataStackView = UIStackView(arrangedSubviews: [makeNoDataLabel(),
                                                     makeAddCSVButton(),
                                                     makeConnectToSalesforceButton()])
    noDataStackView!.spacing = 37
    noDataStackView!.axis = .vertical
    noDataStackView!.distribution = .fillEqually
    noDataStackView!.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(noDataStackView!)
    
    let constraints = [
      noDataStackView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      noDataStackView!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      noDataStackView!.widthAnchor.constraint(equalToConstant: 320),
      noDataStackView!.heightAnchor.constraint(equalToConstant: 250)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func removeNoDataViews() {
    noDataStackView?.removeFromSuperview()
    noDataStackView = nil
  }
  
  private func makeNoDataLabel() -> UILabel {
    let noDataLabel = UILabel()
    noDataLabel.translatesAutoresizingMaskIntoConstraints = false
    noDataLabel.font = UIFont.systemFont(ofSize: 22)
    noDataLabel.textColor = .black
    noDataLabel.numberOfLines = 2
    noDataLabel.textAlignment = .center
    noDataLabel.text = "Oops! It doesn't look like there's any data here yet!"
    return noDataLabel
  }
  
  private func makeAddCSVButton() -> UIView {
    let button = CommonButton(style: .outline)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("ADD .CSV", for: .normal)
    button.addTarget(self, action: #selector(importTapped), for: .touchUpInside)
    
    button.heightAnchor.constraint(equalToConstant: 65).isActive = true
    button.widthAnchor.constraint(equalToConstant: 156).isActive = true
    
    let containerView = UIView()
    containerView.addSubview(button)
    button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    
    return containerView
  }
  
  private func makeConnectToSalesforceButton() -> UIView {
    let button = CommonButton(style: .outline)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Connect to Salesforce", for: .normal)
    button.addTarget(self, action: #selector(connectToSalesforceTapped), for: .touchUpInside)
    
    button.heightAnchor.constraint(equalToConstant: 65).isActive = true
    button.widthAnchor.constraint(equalToConstant: 300).isActive = true
    
    let containerView = UIView()
    containerView.addSubview(button)
    button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    
    return containerView
  }
  
  private func removeTableView() {
    collectionView.removeFromSuperview()
    collectionView = nil
  }
  
  private func removeDeleteButton() {
    deleteButton.removeFromSuperview()
    deleteButton = nil
  }
  
  private func configureHelloLabel() {
    helloLabel = UILabel()
    helloLabel.font = .openSans(weight: .bold, size: 48)
    let text: String
    if let name = Lifecycle.currentUser?.firstName {
      text = "👋 Hello, \(name)"
    } else {
      text = "👋 Hello!"
    }
    
    helloLabel.text = text
    helloLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(helloLabel)
    
    let constraints = [
      helloLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 38),
      helloLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
      helloLabel.heightAnchor.constraint(equalToConstant: 64)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureSubHelloLabel() {
    subHelloLabel = UILabel()
    subHelloLabel.font = .openSans(weight: .regular, size: 24)
    
    subHelloLabel.text = "Here's a look at the accounts you're tracking…"
    subHelloLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(subHelloLabel)
    
    let constraints = [
      subHelloLabel.leftAnchor.constraint(equalTo: helloLabel.leftAnchor, constant: 0),
      subHelloLabel.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 0),
      subHelloLabel.heightAnchor.constraint(equalToConstant: 28)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 50.0
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .primaryBackground
    collectionView.register(MainCollectionCell<MainTableCell>.self, forCellWithReuseIdentifier: MainCollectionCell<MainTableCell>.id())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(collectionView)
    
    let constraints = [
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
      collectionView.topAnchor.constraint(equalTo: subHelloLabel.bottomAnchor, constant: 40),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureSignOutButton() {
    signOutButton = UIButton()
    signOutButton.setImage(UIImage(named: "signOutTEMP"), for: .normal)
    signOutButton.imageView?.contentMode = .scaleAspectFit
    signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
    signOutButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(signOutButton)
    
    let constraints = [
      signOutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
      signOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
      signOutButton.heightAnchor.constraint(equalToConstant: 25),
      signOutButton.widthAnchor.constraint(equalToConstant: 25)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureDeleteButton() {
    deleteButton = UIButton()
    deleteButton.setImage(UIImage(named: "delete"), for: .normal)
    deleteButton.imageView?.contentMode = .scaleAspectFit
    deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    deleteButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(deleteButton)
    
    let constraints = [
      deleteButton.rightAnchor.constraint(equalTo: signOutButton.leftAnchor, constant: -12),
      deleteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
      deleteButton.heightAnchor.constraint(equalToConstant: 25),
      deleteButton.widthAnchor.constraint(equalToConstant: 25)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureReloadButton() {
    reloadButton = UIButton()
    reloadButton.setImage(UIImage(named: "reloadIcon"), for: .normal)
    reloadButton.imageView?.contentMode = .scaleAspectFit
    reloadButton.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
    reloadButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(reloadButton)
    
    let constraints = [
      reloadButton.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: -12),
      reloadButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
      reloadButton.heightAnchor.constraint(equalToConstant: 25),
      reloadButton.widthAnchor.constraint(equalToConstant: 25)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  @objc
  private func signOutTapped() {
    Lifecycle.logOut()
  }
  
  @objc
  private func deleteTapped() {
    interactor.deleteAccounts()
    interactor.endSalesforceSession()
    removeTableView()
    removeDeleteButton()
    configureNoDataViews()
  }
  
  @objc
  private func reloadTapped() {
    interactor.getAccounts()
  }
  
  func reloadCollection() {
    collectionView?.reloadData()
  }

  @objc
  private func importTapped() {
    let picker = DocumentPickerViewController(
        supportedTypes: ["public.comma-separated-values-text"],
        onPick: { url in
          self.interactor.parseAccountsAndContacts(from: url)
          self.configureViewsForContent()
        },
        onDismiss: {}
    )
    UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
  }
  
  @objc
  private func connectToSalesforceTapped() {    
    let sfAuthSession = interactor.makeSFAuthenticationSession(completion: { [weak self] in
      self?.configureViewsForContent()
    })
    sfAuthSession?.presentationContextProvider = self
    sfAuthSession?.start()
  }
}

extension URL {
  func fragmentValueOf(_ name: String) -> String? {
    var components = URLComponents()
    components.query = fragment
    return components.queryItems?.first(where: { $0.name == name })?.value
  }
}

extension MainViewController: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return view.window!
  }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return interactor.accountStates.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionCell<MainTableCell>.id(), for: indexPath) as? MainCollectionCell<MainTableCell> else {
      return UICollectionViewCell()
    }
  //    let state = interactor.accountStates[indexPath.section]
  //    let account = interactor.accountGrouper[state][indexPath.row]
    cell.section = indexPath.row
    cell.dataSource = interactor
    cell.delegate = self
    return cell
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width * 0.2342, height: collectionView.frame.size.height)
  }
}

extension MainViewController: MainCollectionCellDelegate {
  func didSelectRowAt(section: Int, didSelectRowAt indexPath: IndexPath) {
    let accountState = interactor.accountStates[section]
    interactor.lastSelected = (accountState, indexPath.row)
    let viewController = AccountDetailsViewController()
    viewController.configure(with: interactor)
    navigationController?.pushViewController(viewController, animated: false)
  }
  
  func didClickAssignButton(_ button: UIButton, forAccount account: Account) {
    interactor.accountBeingAssigned = account
    let viewController = TablePopoverViewController()
    viewController.modalPresentationStyle = .popover
    viewController.provider = OrgUsersProvider()
    viewController.delegate = self
    navigationController?.present(viewController, animated: true, completion: nil)
    let popoverVC = viewController.popoverPresentationController
    popoverVC?.permittedArrowDirections = [.left, .up, .right]
    popoverVC?.sourceView = button
  }
}

struct OrgUser: SimpleItem {
  var name = ""
  var icon: UIImage?
}

struct OrgUsersProvider: SimpleItemProviding {
  func getItems(success: ([SimpleItem]) -> Void, failure: (Error) -> Void) {
    guard let users = Lifecycle.currentUser?.organization?.users else {
      let error = CustomError("Failed to get users from Organization.")
      Log.error(error.localizedDescription)
      failure(error)
      return
    }
    success(users)
  }
}
    
extension MainViewController: TablePopoverViewControllerDelegate {
  func didSelectItem(_ item: SimpleItem) {
    guard let user = item as? User,
          let account = interactor.accountBeingAssigned else { return }
    interactor.assign(user, to: account)
  }
}
