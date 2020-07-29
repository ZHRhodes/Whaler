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
  
  func makeUIViewController(context: Context) -> ContactsTableViewController {
    return ContactsTableViewController()
  }
  
  func updateUIViewController(_ uiViewController: ContactsTableViewController, context: Context) {
    
  }
}

class ContactsTableViewController: UIViewController {
  let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.backgroundColor = .blue
    
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

