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
  func getItems(success: ([SimpleItem]) -> Void, error: (Error) -> Void)
}

protocol TablePopoverViewControllerDelegate: class {
  func didSelect
}

class TablePopoverViewController: UIViewController {
  private let tableView = UITableView()
  var provider: SimpleItemProviding? {
    didSet {
      provider?.getItems(success: { (items) in
        self.items = items
      }, error: { error in
        print(error)
        //TODO log this
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
    preferredContentSize = CGSize(width: 300, height: 200)
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    tableView.reloadData()
  }
}

extension TablePopoverViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let item = items[indexPath.row]
    cell.textLabel?.text = item.name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
}

extension TablePopoverViewController: UITableViewDelegate {
  
}
