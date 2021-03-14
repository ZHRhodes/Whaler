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
  private var secondaryTableVC: UIViewController?
  private var loadingView: UIView?
  
  var optionsProvider: FilterOptionsProviding? {
    didSet {
      optionsProvider?.fetchOptions(completion: { [weak self] (providers) in
        self?.filters = providers
      })
    }
  }
  
  private var filters: [FilterProviding]? {
    didSet {
      hideLoadingIndicator()
      configureTableView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preferredContentSize = CGSize(width: 200, height: 300)
    view.backgroundColor = .clear
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if filters == nil {
      showLoadingIndicator()
    }
  }
  
  private func configureTableView() {
    tableView.register(FilterPopoverTableCell.self,
                       forCellReuseIdentifier: FilterPopoverTableCell.id)
    tableView.backgroundColor = .primaryBackground
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addAndAttach(view: tableView,
                      width: 200.0,
                      attachingEdges: [.left(0), .top(0), .bottom(0)])
  }
  
  private func showLoadingIndicator() {
    loadingView = UIView()
    let progressView = ProgressView.makeDefaultStyle()
    loadingView!.addAndAttach(view: progressView,
                              height: 30,
                              width: 30,
                              attachingEdges: [.centerY(0), .centerX(0)])
    view.addAndAttach(view: loadingView!, attachingEdges: [.all(0)])
    progressView.isAnimating = true
  }
  
  private func hideLoadingIndicator() {
    loadingView?.removeFromSuperview()
    loadingView = nil
  }
  
  private func showPopover(for cell: FilterPopoverTableCell) {
    secondaryTableVC?.view.removeFromSuperview()
    guard let optionsProvider = cell.filterOption?.optionsProvider else {
      shrinkPopoverIfNecessary()
      return
    }
    
    preferredContentSize = CGSize(width: 400, height: 300)
    let viewController = FilterPopoverViewController()
//    viewController.delegate = self
    viewController.optionsProvider = optionsProvider
    secondaryTableVC = viewController
    self.view.addAndAttach(view: viewController.view,
                           attachingEdges: [.left(0, equalTo: tableView.rightAnchor),
                                            .top(0),
                                            .right(0),
                                            .bottom(0)])
  }
  
  private func shrinkPopoverIfNecessary() {
    secondaryTableVC?.view.removeFromSuperview()
    preferredContentSize = CGSize(width: 200, height: 300)
  }
}

extension FilterPopoverViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filters?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FilterPopoverTableCell.id)
    guard let filterCell = cell as? FilterPopoverTableCell,
          let filters = filters else { return UITableViewCell() }
    
    let filter = filters[indexPath.row]
    filterCell.filterOption = filter
    
    return filterCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? FilterPopoverTableCell else { return }
    showPopover(for: cell)
  }
}
