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
  static let minSize = CGSize(width: 500, height: 500)
  static let maxSize = CGSize(width: .max, height: .max)
  
  let interactor = MainInteractor()
  var noDataStackView: UIStackView?
  var tableView: UITableView!
  var deleteButton: UIButton!
  
  private var sectionHeaders = Set<WeakRef<UIView>>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Accounts"
    view.backgroundColor = .white
    
    if interactor.hasNoAccounts {
      if interactor.hasSalesforceTokens {
        //present loading indicator
        interactor.refreshSalesforceSession { [weak self] (success) in
          if success {
            self?.interactor.fetchAccountsFromSalesforce()
            self?.configureViewsForContent()
          } else {
            self?.configureNoDataViews()
          }
        }
      } else {
        configureNoDataViews()
      }
    } else {
      configureNoDataViews()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  private func configureViewsForContent() {
    removeNoDataViews()
    configureTableView()
    configureDeleteButton()
  }
  
  private func configureNoDataViews() {
    noDataStackView = UIStackView(arrangedSubviews: [makeNoDataLabel(),
                                                     makeAddCSVButton(),
                                                     makeConnectToSalesforceButton()])
    noDataStackView!.spacing = 37
    noDataStackView!.axis = .vertical
    noDataStackView?.distribution = .fillEqually
    noDataStackView?.translatesAutoresizingMaskIntoConstraints = false
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
  
  private func configureTableView() {
    tableView = UITableView(frame: .zero, style: .plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.dragInteractionEnabled = true
    tableView.dragDelegate = self
    tableView.dropDelegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor =  .white
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.register(AccountTableCell.self, forCellReuseIdentifier: AccountTableCell.id)
    tableView.register(MainTableSectionHeader.self, forHeaderFooterViewReuseIdentifier: MainTableSectionHeader.id)
    view.addSubview(tableView)
    
    let constraints = [
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 31),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -31),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func removeTableView() {
    tableView.removeFromSuperview()
    tableView = nil
  }
  
  private func removeDeleteButton() {
    deleteButton.removeFromSuperview()
    deleteButton = nil
  }
  
  private func configureDeleteButton() {
    deleteButton = UIButton()
    deleteButton.setImage(UIImage(named: "tripleDotsTEMP"), for: .normal)
    deleteButton.imageView?.contentMode = .scaleAspectFit
    deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    deleteButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(deleteButton)
    
    let constraints = [
      deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
      deleteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
      deleteButton.heightAnchor.constraint(equalToConstant: 25),
      deleteButton.widthAnchor.constraint(equalToConstant: 25)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  @objc
  private func deleteTapped() {
    interactor.deleteAccounts()
    removeTableView()
    removeDeleteButton()
    configureNoDataViews()
  }

  @objc
  private func importTapped() {
    let picker = DocumentPickerViewController(
        supportedTypes: ["public.comma-separated-values-text"],
        onPick: { url in
          self.interactor.parseAccountsAndContacts(from: url)
          self.removeNoDataViews()
          self.configureTableView()
          self.configureDeleteButton()
        },
        onDismiss: {}
    )
    UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
  }
  
  @objc
  private func connectToSalesforceTapped() {    
    let sfAuthSession = interactor.makeSFAuthenticationSession(completion: { [weak self] in
      self?.removeNoDataViews()
      self?.configureTableView()
      self?.configureDeleteButton()
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

extension MainViewController: UIDropInteractionDelegate {
  func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: String.self)
  }

  func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    //only want external app sessions
    if session.localDragSession == nil {
      return UIDropProposal(operation: .copy)
    }
    return UIDropProposal(operation: .cancel)
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let state = interactor.accountStates[section]
    return interactor.accountGrouper[state].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableCell.id) as? AccountTableCell else {
      return UITableViewCell()
    }
    let state = interactor.accountStates[indexPath.section]
    let account = interactor.accountGrouper[state][indexPath.row]
    cell.configure(with: account)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return interactor.accountStates.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainTableSectionHeader.id) as? MainTableSectionHeader
    let state = interactor.accountStates[section]
    let values = ["Account", "Contacts", "Industry", "City", "State"]
    header?.configure(state: state, values: values)
    return header
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    sectionHeaders.remove(WeakRef(value: view))
  }
  
  func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
    sectionHeaders.insert(WeakRef(value: view))
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let accountState = interactor.accountStates[indexPath.section]
    let account = interactor.accountGrouper[accountState][indexPath.row]
    interactor.retrieveAndAssignContacts(for: account)
    let view = AccountDetailsView(account: account)
    let viewController = UIHostingController(rootView: view)
    navigationController?.pushViewController(viewController, animated: false)
  }
}

extension MainViewController: UITableViewDragDelegate, UITableViewDropDelegate {
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let state = interactor.accountStates[indexPath.section]
    let account = interactor.accountGrouper[state][indexPath.row]
    let itemProvider = NSItemProvider(object: account)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    return [dragItem]
  }
  
  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
    return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
  
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    let insertionIndex: IndexPath
    if let indexPath = coordinator.destinationIndexPath {
      insertionIndex = indexPath
    } else {
      let section = tableView.numberOfSections - 1
      let row = tableView.numberOfRows(inSection: section)
      insertionIndex = IndexPath(row: row, section: section)
    }
    
    for item in coordinator.items {
      guard let sourceIndexPath = item.sourceIndexPath else { continue }
      item.dragItem.itemProvider.loadObject(ofClass: Account.self) { (object, error) in
        DispatchQueue.main.async {
          self.interactor.moveAccount(from: sourceIndexPath, to: insertionIndex)
          self.tableView.reloadData()
        }
      }
    }
  }
}
