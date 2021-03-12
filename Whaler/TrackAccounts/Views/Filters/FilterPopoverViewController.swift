//
//  FilterPopoverViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/11/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

protocol FilterPopoverViewControllerDelegate: class {
}

class FilterPopoverViewController: UIViewController {
  weak var delegate: FilterPopoverViewControllerDelegate?
  private let tableView = UITableView()
  var filters: [FilterProviding] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preferredContentSize = CGSize(width: 200, height: 300)
    view.backgroundColor = .clear
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.backgroundColor = .primaryBackground
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addAndAttach(view: tableView, width: 200.0, attachingEdges: [.left(0), .top(0), .bottom(0)])
  }
  
  @objc
  private func hovering(_ recognizer: UIHoverGestureRecognizer) {
    #if targetEnvironment(macCatalyst)
    switch recognizer.state {
    case .began, .changed:
      showPopoverOnHover(view: recognizer.view!)
    case .ended:
      //hide popover
    break
    default:
      break
    }
    #endif
  }
  
  private func showPopoverOnHover(view: UIView) {
    preferredContentSize = CGSize(width: 400, height: 300)
    let viewController = FilterPopoverViewController()
//    viewController.delegate = self
    viewController.filters = [FilterProvider(name: "Option", optionsProvider: nil)]
    self.view.addAndAttach(view: viewController.view, attachingEdges: [.left(0, equalTo: tableView.rightAnchor), .top(0), .right(0), .bottom(0)])
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
    let hover = UIHoverGestureRecognizer(target: self, action: #selector(hovering(_:)))
    cell.addGestureRecognizer(hover)
    return cell
  }
}


