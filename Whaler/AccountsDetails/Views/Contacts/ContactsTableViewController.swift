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
  var contactGrouper: Grouper<WorkState, Contact>
  
  func makeUIViewController(context: Context) -> ContactsTableViewController {
    return ContactsTableViewController(contactGrouper: contactGrouper)
  }
  
  func updateUIViewController(_ uiViewController: ContactsTableViewController, context: Context) {
    
  }
}

class ContactsTableViewController: UIViewController {
  private let tableView = UITableView()
  private var contactGrouper: Grouper<WorkState, Contact>
  private var contactBeingAssigned: Contact?
  
  init(contactGrouper: Grouper<WorkState, Contact>) {
    self.contactGrouper = contactGrouper
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
    guard let contactBeingMoved = contactGrouper.remove(from: fromState, at: fromPath.row) else { return }

    let toState = WorkState.allCases[toPath.section]
    contactBeingMoved.state = toState
    contactGrouper.insert(contactBeingMoved, to: toState, at: toPath.row)
    
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
    let numberOfRows = contactGrouper[state].count
    return numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let state = WorkState.allCases[indexPath.section]
    let contact = contactGrouper[state][indexPath.row]
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactRowViewCell.id) as? ContactRowViewCell else {
      return UITableViewCell()
    }
    cell.configure(withContact: contact)
    cell.delegate = self
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return ContactRowViewCell.height
  }
}

extension ContactsTableViewController: UITableViewDragDelegate, UITableViewDropDelegate {
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let state = WorkState.allCases[indexPath.section]
    let contact = contactGrouper[state][indexPath.row]
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

extension ContactsTableViewController: ContactRowViewCellDelegate {
  func didClickAssignButton(_ button: UIView, forContact contact: Contact) {
    contactBeingAssigned = contact
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

extension ContactsTableViewController: TablePopoverViewControllerDelegate {
  func didSelectItem(_ item: SimpleItem) {
    guard let contact = contactBeingAssigned,
          let currentUser = Lifecycle.currentUser,
          let selectedUser = item as? User else { return }
    let mutation = CreateContactAssignmentEntryMutation(contactId: contact.id, //TEMP
                                                        assignedBy: String(currentUser.id),
                                                        assignedTo: String(selectedUser.id))
    Graph.shared.apollo.perform(mutation: mutation) { result in
      print(result)
    }
//    let input = CreateContactAssignmentEntryMutation
//    let mutation = CreateContactAssignmentEntryMutation()
//    Graph.shared.apollo.mutation(mutation)
  }
}
