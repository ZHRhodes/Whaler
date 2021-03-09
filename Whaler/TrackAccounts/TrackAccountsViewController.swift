//
//  TrackAccountsViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class TrackAccountsViewController: ToolbarContainingViewController {
  private let interactor = TrackAccountsInteractor()
  private let tableView = UITableView()
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      updateColors()
      tableView.setNeedsDisplay()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .primaryBackground
    configureTableView()
    interactor.viewController = self
    interactor.fetchAccounts()
  }
  
  private func configureTableView() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .primaryBackground
    tableView.delegate = self
    tableView.dataSource = self
    tableView.layer.cornerRadius = 10.0
    tableView.layer.borderWidth = 2.0
    tableView.layer.borderColor = UIColor.primaryText.cgColor
    tableView.register(TrackAccountsTableCell.self, forCellReuseIdentifier: TrackAccountsTableCell.id)
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
    ])
  }
  
  private func updateColors() {
    tableView.layer.borderColor = UIColor.primaryText.cgColor
  }
  
  func didFetchAccounts() {
    tableView.reloadData()
  }
}

extension TrackAccountsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return interactor.accounts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TrackAccountsTableCell.id)
    guard let trackAccountsCell = cell as? TrackAccountsTableCell else { return UITableViewCell() }
    trackAccountsCell.dataSource = interactor.accounts[indexPath.row]
    return trackAccountsCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}
