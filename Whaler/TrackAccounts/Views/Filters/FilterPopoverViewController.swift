//
//  FilterPopoverViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/11/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class FilterPopoverViewController: UIViewController {
  private let tableView = UITableView()
  var filters: [FilterProviding] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preferredContentSize = CGSize(width: 200, height: 300)
    view.backgroundColor = .primaryBackground
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.backgroundColor = .primaryBackground
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addAndAttach(view: tableView, attachingEdges: [.all(0)])
  }
}

extension FilterPopoverViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filters.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let filter = filters[indexPath.row]
    cell.textLabel?.text = filter.name
    cell.textLabel?.tintColor = .primaryText
    cell.backgroundColor = .primaryBackground
    return cell
  }
}


