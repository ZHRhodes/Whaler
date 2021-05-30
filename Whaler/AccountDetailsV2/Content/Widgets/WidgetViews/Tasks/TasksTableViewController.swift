//
//  TasksTable.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit
import Combine

class TasksTableViewController: UIViewController {
  var interactor: TasksTableInteractor!
  private let tableView = UITableView()
  private var datePicker: UIDatePicker?
  private var dataChangeCancellable: AnyCancellable?
  private var taskBeingAssigned: Task?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    view.heightAnchor.constraint(equalToConstant: 300).isActive = true
  }
  
  func configure(with interactor: TasksTableInteractor) {
    self.interactor = interactor
    dataChangeCancellable = interactor.dataChanged.sink(receiveValue: { [weak self] in
      self?.tableView.reloadData()
    })
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
    let task = interactor.tasks[indexPath.row]
    cell.configure(with: task)
    cell.delegate = self
    return cell
  }
}

extension TasksTableViewController: TaskTableCellDelegate {
  func changedDescription(new: String, forTask task: Task) {
    interactor.setDescription(new: new, forTask: task)
  }
  
  func changedDate(newDate: Date, forTask task: Task) {
    interactor.setDate(newDate: newDate, forTask: task)
  }
	
	func didClickAssignButton(_ button: UIButton, forTask task: Task) {
    self.taskBeingAssigned = task
		let viewController = TablePopoverViewController()
		viewController.modalPresentationStyle = .popover
		viewController.provider = OrgUsersProvider()
		viewController.delegate = self
		present(viewController, animated: true, completion: nil)
		let popoverVC = viewController.popoverPresentationController
		popoverVC?.permittedArrowDirections = [.left, .up, .right]
		popoverVC?.sourceView = button
	}
}

extension TasksTableViewController: TablePopoverViewControllerDelegate {
	func didSelectItem(_ item: SimpleItem) {
    dismiss(animated: true) { [weak self] in
      guard let strongSelf = self,
            let task = strongSelf.taskBeingAssigned,
            let selectedUser = item as? User else { return }
      strongSelf.interactor.assign(task: task, to: selectedUser.id)
      strongSelf.taskBeingAssigned = nil
    }
	}
}
