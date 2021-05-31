//
//  AccountDetailsContentViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/15/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit
import Starscream

class AccountDetailsContentViewController: UIViewController {
  private var interactor: AccountDetailsContentInteractor!
  private var titleLabel = UILabel()
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
		layout.minimumLineSpacing = 16
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
//  private var subtitleLabel = UILabel()
//  private let detailsGrid = DetailsGrid()
  private let contactsVC = AccountDetailsContactsViewController()
  private let tasksVC = TasksTableViewController()
  private lazy var tasksTableInteractor = TasksTableInteractor(associatedObjectId: self.interactor.account.id)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTitleLabel()
    configureCollectionView()
//    configureSubtitleLabel()
  }
  
  
  //TODO: this getting called infinitely?
  override func viewDidLayoutSubviews() {
    let width = collectionView.bounds.width
    if width > 0 {
      collectionView.visibleCells.forEach { (cell) in
        if cell.frame.width != width {
          (cell as? AccountWidgetCell)?.setWidth(width)
        }
      }
    }
    super.viewDidLayoutSubviews()
  }
  
  func configure(with interactor: AccountDetailsContentInteractor) {
    self.interactor = interactor
    WebSocketManager.shared.info(for: interactor.socket)?.delegates.add(delegate: self)
//    configureDetailsGrid()
//    configureContactsSection()
  }
  
  private func configureCollectionView() {
    collectionView.backgroundColor = .primaryBackground
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(AccountWidgetCell.self, forCellWithReuseIdentifier: AccountWidgetCell.id)
    view.addAndAttach(view: collectionView, attachingEdges: [.left(),
                                                             .bottom(),
                                                             .right(),
                                                             .top(16, equalTo: titleLabel.bottomAnchor)])
  }
  
//
//  private func configureContactsSection() {
//    let interactor = AccountDetailsContactsInteractor(dataManager: self.interactor.dataManager)
//    contactsVC.configure(with: interactor)
//    contactsVC.view.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(contactsVC.view)
//    contactsVC.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//    contactsVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65).isActive = true
//    contactsVC.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//    contactsVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//  }
  
  private func configureTitleLabel() {
    titleLabel = UILabel()
    titleLabel.font = .openSans(weight: .bold, size: 48)
    let accountName = interactor.account.name
    let text = "📒 \(accountName)"
    
    titleLabel.text = text
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleLabel)
    
    let constraints = [
      titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      titleLabel.heightAnchor.constraint(equalToConstant: 64)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
}

extension AccountDetailsContentViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return interactor.widgets.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let widget = interactor.widgets[indexPath.row]
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountWidgetCell.id, for: indexPath) as? AccountWidgetCell else {
      return UICollectionViewCell()
    }
    switch widget {
    case .details(let detailsProvider):
      let gridView = DetailsGrid()
      gridView.configure(with: detailsProvider)
      cell.configure(title: "ACCOUNT DETAILS", content: gridView)
    case .tasks(let tasksProvider):
      tasksVC.configure(with: tasksTableInteractor)
      let button = AddTaskButton(frame: .zero)
      button.addTarget(interactor, action: #selector(tasksTableInteractor.addTask), for: .touchUpInside)
      cell.configure(title: "TASKS", accessoryButton: button, content: tasksVC.view)
    case .contacts(let contactsProvider):
			let interactor = AccountDetailsContactsInteractor(dataManager: self.interactor.dataManager)
			contactsVC.configure(with: interactor)
      cell.configure(title: "CONTACTS", content: contactsVC.view)
		}
    
    return cell
  }
}

extension AccountDetailsContentViewController: LiteWebSocketDelegate {
  func didReceiveMessage(_ message: SocketMsg, socket: WebSocketClient) {
    switch message {
    case .resourceUpdated(let update):
      if update.resourceId == interactor.account.id {
        tasksTableInteractor.refetchTasks()
      }
    default:
      break
    }
  }
  
  func connectionEstablished(socket: WebSocketClient) {}
}
