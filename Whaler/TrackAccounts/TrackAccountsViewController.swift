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
  private let titleLabel = UILabel()
  private var actionsStack: UIStackView!
  private let tableView = ContentSizedTableView()
  private let pageSelector = PageSelectorView()
  private var visiblePage = 1
  private var filterPopover: FilterPopoverViewController?
  
  private let filterStack = UIStackView()
  private lazy var addFilterView: AddFilterView = {
    let view = AddFilterView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    return view
  }()
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateColors()
    tableView.setNeedsDisplay()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .primaryBackground
    configurePageTitle()
    configureTableView()
    configureActionsStackView()
    configurePageSelector()
    configureFilterStack()
    interactor.viewController = self
    interactor.fetchAccounts()
  }
  
  private func configurePageTitle() {
    titleLabel.font = .openSans(weight: .bold, size: 48)
    titleLabel.text = "🗂 Track Accounts"
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 38),
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
      titleLabel.heightAnchor.constraint(equalToConstant: 64),
    ])
  }
  
  private func configureActionsStackView() {
    actionsStack = UIStackView(arrangedSubviews: [
      makeUserView(),
    ])
    actionsStack.axis = .horizontal
    actionsStack.spacing = 20
    actionsStack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(actionsStack)
    NSLayoutConstraint.activate([
      actionsStack.rightAnchor.constraint(equalTo: tableView.rightAnchor, constant: 0),
      actionsStack.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -8),
      actionsStack.heightAnchor.constraint(equalToConstant: 65),
    ])
  }
  
  private func configurePageSelector() {
    pageSelector.delegate = self
    view.addAndAttach(view: pageSelector,
                      height: 33,
                      attachingEdges: [
                        .right(0, equalTo: tableView.rightAnchor),
                        .bottom(-27, equalTo: tableView.topAnchor)
    ])
  }
  
  func setNumberOfPages(_ number: Int) {
    pageSelector.totalPages = number
  }
  
  private func makeUserView() -> UIView {
    let userView = CurrentUserView()
    userView.text = Lifecycle.currentUser?.initials
    userView.backgroundColor = .brandPurple
    let size: CGFloat = 65.0
    userView.layer.cornerRadius = size/2
    userView.widthAnchor.constraint(equalToConstant: size).isActive = true
    userView.heightAnchor.constraint(equalTo: userView.widthAnchor).isActive = true
    return userView
  }
  
  private func configureFilterStack() {
    filterStack.axis = .horizontal
    filterStack.spacing = 16.0
    filterStack.distribution = .fillProportionally
    view.addAndAttach(view: filterStack, height: 48, attachingEdges: [.left(0, equalTo: tableView.leftAnchor), .bottom(0, equalTo: pageSelector.bottomAnchor)])
    
    view.addAndAttach(view: addFilterView,
                      attachingEdges: [.left(16.0, equalTo: filterStack.rightAnchor),
                                       .bottom(0, equalTo: filterStack.bottomAnchor)])
  }
  
  private func configureTableView() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .primaryBackground
    tableView.isScrollEnabled = false
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
      tableView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
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
    return min(interactor.accountsTableData[visiblePage]?.count ?? 0, interactor.pageSize)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TrackAccountsTableCell.id)
    guard let trackAccountsCell = cell as? TrackAccountsTableCell else { return UITableViewCell() }
    trackAccountsCell.dataSource = interactor.accountsTableData[visiblePage]![indexPath.row]
    return trackAccountsCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return TrackAccountsTableCell.height
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = TrackAccountsTableCell()
    headerView.dataSource = TrackAccountsTableData(accountName: "Account",
                                                   industry: "Industry",
                                                   billingCity: "City",
                                                   billingState: "State",
                                                   contactCount: "Contacts",
                                                   style: .header)
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return TrackAccountsTableCell.height
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? TrackAccountsTableCell else { return }
    cell.isChecked = !cell.isChecked
  }
}

extension TrackAccountsViewController: PageSelectorDelegate {
  func backButtonTapped() {
    visiblePage = max(visiblePage - 1, 1)
    tableView.reloadData()
  }
  
  func forwardButtonTapped() {
    visiblePage = min(visiblePage + 1, interactor.numberOfPages)
    tableView.reloadData()
  }
}

extension TrackAccountsViewController: AddFilterViewDelegate {
  func tapped() {
    filterPopover = FilterPopoverViewController()
    filterPopover!.delegate = self
    filterPopover!.modalPresentationStyle = .popover
    filterPopover!.optionsProvider = BaseOptionsProvider()
    navigationController?.present(filterPopover!, animated: true, completion: nil)
    let popoverVC = filterPopover!.popoverPresentationController
    popoverVC?.permittedArrowDirections = [.up]
    popoverVC?.sourceView = addFilterView
  }
}


extension TrackAccountsViewController: FilterPopoverViewControllerDelegate {
  func selected(filter: FilterProviding) {
    filterPopover?.dismiss(animated: true, completion: nil)
    let filterView = FilterValueView()
    filterView.setText(type: filter.group.rawValue, value: filter.name)
    filterView.translatesAutoresizingMaskIntoConstraints = false
    filterStack.addArrangedSubview(filterView)
  }
}
