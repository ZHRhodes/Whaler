//
//  TablePopoverViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/8/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

protocol NameProviding {
  var name: String { get }
}

protocol IconProviding {
  var icon: UIImage? { get }
}

typealias SimpleItem = NameProviding & IconProviding

protocol SimpleItemProviding {
  func getItems(success: ([SimpleItem]) -> Void, failure: (Error) -> Void)
}

protocol TablePopoverViewControllerDelegate: class {
  func didSelectItem(_ item: SimpleItem)
}

class TablePopoverViewController: UIViewController {
  weak var delegate: TablePopoverViewControllerDelegate?
  private let tableView = UITableView()
  var provider: SimpleItemProviding? {
    didSet {
      provider?.getItems(success: { (items) in
        self.items = items
      }, failure: { error in
        
      })
    }
  }
  
  private var items = [SimpleItem]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    modalPresentationStyle = .popover
    preferredContentSize = CGSize(width: 300, height: 200)
    view.backgroundColor = .primaryBackground
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.backgroundColor = .primaryBackground
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    tableView.reloadData()
  }
}

extension TablePopoverViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let item = items[indexPath.row]
    cell.textLabel?.text = item.name
    cell.textLabel?.tintColor = .primaryText
    cell.backgroundColor = .primaryBackground
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    delegate?.didSelectItem(item)
  }
}
