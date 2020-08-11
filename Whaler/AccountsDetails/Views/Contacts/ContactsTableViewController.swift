//
//  ContactsTableViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import SwiftUI

struct ContactsTableViewControllerRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = ContactsTableViewController
  var contacts: [WorkState: [Contact]]
  
  func makeUIViewController(context: Context) -> ContactsTableViewController {
    return ContactsTableViewController(contacts: contacts)
  }
  
  func updateUIViewController(_ uiViewController: ContactsTableViewController, context: Context) {
    
  }
}

class ContactsTableViewController: UIViewController {
  private let tableView = UITableView()
  private var contacts: [WorkState: [Contact]]
  
  init(contacts: [WorkState: [Contact]]) {
    self.contacts = contacts
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dragDelegate = self
    tableView.dropDelegate = self
    tableView.dragInteractionEnabled = true
    tableView.register(ContactRowViewCell.self, forCellReuseIdentifier: ContactRowViewCell.id)
    
    view.addSubview(tableView)
    let constraints = [
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
      tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
  func moveContact(from fromPath: IndexPath, to toPath: IndexPath) {
    let fromState = WorkState.allCases[fromPath.section]
    guard let contactBeingMoved = contacts[fromState]?.remove(at: fromPath.row) else { return }

    let toState = WorkState.allCases[toPath.section]
    contactBeingMoved.state = toState
    contacts[toState]?.insert(contactBeingMoved, at: toPath.row)
    
    ObjectManager.save(contactBeingMoved) //Move, or make this async, or both
  }
}

extension ContactsTableViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return WorkState.allCases.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let state = WorkState.allCases[section]
    let view = AccountStateTagView(state: state, sidePadding: 16, fontSize: 17.0)
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 55
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView()
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 20
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let state = WorkState.allCases[section]
    let numberOfRows = contacts[state]?.count ?? 0
    return numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let state = WorkState.allCases[indexPath.section]
    guard let contact = contacts[state]?[indexPath.row],
          let cell = tableView.dequeueReusableCell(withIdentifier: ContactRowViewCell.id) as? ContactRowViewCell else {
      return UITableViewCell()
    }
    cell.configure(withContact: contact)
    return cell
  }
}

extension ContactsTableViewController: UITableViewDragDelegate, UITableViewDropDelegate {
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let state = WorkState.allCases[indexPath.section]
    let contact = contacts[state]![indexPath.row]
    let itemProvider = NSItemProvider(object: contact)
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
      item.dragItem.itemProvider.loadObject(ofClass: Contact.self) { (object, error) in
        DispatchQueue.main.async {
          self.moveContact(from: sourceIndexPath, to: insertionIndex)
          self.tableView.reloadData()
        }
      }
    }
  }
}


