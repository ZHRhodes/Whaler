//
//  TasksTable.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class TasksTableViewController: UIViewController {
  var interactor: TasksTableInteractor!
  private let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    view.heightAnchor.constraint(equalToConstant: 300).isActive = true
  }
  
  func configure(with interactor: TasksTableInteractor) {
    self.interactor = interactor
  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .accentBackground
    tableView.layer.cornerRadius = UIConstants.boxCornerRadius
    tableView.register(TaskTableCell.self,
                       forCellReuseIdentifier: TaskTableCell.id)
    view.addAndAttachToEdges(view: tableView)
  }
}

extension TasksTableViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return interactor.tasks.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return TaskTableCell.cellHeight
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableCell.id) as? TaskTableCell else {
      return UITableViewCell()
    }
    return cell
  }
}
