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
    view.backgroundColor = .red
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.backgroundColor = .blue
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(tableView)
    let constraints = [
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
      tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
    ]
    NSLayoutConstraint.activate(constraints)
  }
}

extension ContactsTableViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return WorkState.allCases.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let state = WorkState.allCases[section]
    let numberOfRows = contacts[state]?.count ?? 0
    return numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let state = WorkState.allCases[indexPath.section]
    cell.textLabel?.text = contacts[state]?[indexPath.row].fullName
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

