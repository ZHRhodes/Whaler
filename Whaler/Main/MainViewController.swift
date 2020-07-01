//
//  MainViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/21/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
  let interactor = MainInteractor()
  var noDataStackView: UIStackView?
  let tableView = UITableView(frame: .zero, style: .plain)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureNoDataViews()
  }
  
  private func configureNoDataViews() {
    noDataStackView = UIStackView(arrangedSubviews: [makeNoDataLabel(), makeAddCSVButton()])
    noDataStackView!.spacing = 37
    noDataStackView!.axis = .vertical
    noDataStackView?.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(noDataStackView!)
    
    let constraints = [
      noDataStackView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      noDataStackView!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      noDataStackView!.widthAnchor.constraint(equalToConstant: 320),
      noDataStackView!.heightAnchor.constraint(equalToConstant: 170)
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
    let button = Button(style: .outline)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.borderColor = UIColor(red: 0.2, green: 0.77, blue: 0.83, alpha: 1.0).cgColor
    button.layer.borderWidth = 2.0
    button.layer.cornerRadius = 4.0
    button.setTitle("ADD .CSV", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(importTapped), for: .touchUpInside)
    
    button.heightAnchor.constraint(equalToConstant: 65).isActive = true
    button.widthAnchor.constraint(equalToConstant: 156).isActive = true
    
    let containerView = UIView()
    containerView.addSubview(button)
    button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    
    return containerView
  }
  
  private func configureTableView() {
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
    view.addSubview(tableView)
    
    let constraints = [
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 31),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -31),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }

  @objc
  private func importTapped() {
    let picker = DocumentPickerViewController(
        supportedTypes: ["public.comma-separated-values-text"],
        onPick: { url in
          self.interactor.parseAccounts(from: url)
          self.removeNoDataViews()
          self.configureTableView()
        },
        onDismiss: {}
    )
    UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
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
    return interactor.accounts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableCell.id) as? AccountTableCell else {
      return UITableViewCell()
    }
    let account = interactor.accounts[indexPath.row]
    cell.configure(with: account)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return interactor.accountStates.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return interactor.accountStates[section].rawValue
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let state = interactor.accountStates[section]
    return MainTableSectionHeader(state: state)
  }
}

extension MainViewController: UITableViewDragDelegate, UITableViewDropDelegate {
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let account = interactor.accounts[indexPath.row]
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
      guard let sourceIndexPathRow = item.sourceIndexPath?.row else { continue }
      item.dragItem.itemProvider.loadObject(ofClass: Account.self) { (object, error) in
        DispatchQueue.main.async {
          guard let account = object as? Account else { return }
          self.interactor.accounts.remove(at: sourceIndexPathRow)
          self.interactor.accounts.insert(account, at: insertionIndex.row)
          self.tableView.reloadData()
        }
      }
    }
  }
}
