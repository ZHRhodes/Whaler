//
//  TrackAccountsViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class TrackAccountsViewController: UIViewController {
  private let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .primaryBackground
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.backgroundColor = .white //temp
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
    ])
  }
}
