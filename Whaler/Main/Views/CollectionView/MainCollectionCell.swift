//
//  MainCollectionCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/26/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

class MainCollectionCell: UICollectionViewCell {
  static let id = "MainCollectionCellId"
  private let tableView = UITableView()
  var section: Int?
  weak var dataSource: MainInteractorData? {
    didSet {
      tableView.reloadData()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  func configure() {
    layer.masksToBounds = true
    layer.cornerRadius = 10.0
    backgroundColor = .white
    configureTableView()
//    let cover = UIView()
//    cover.backgroundColor = .orange
//    addAndAttachToEdges(view: cover)
  }
  
  func configureTableView() {
    tableView.backgroundColor = .white
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(MainTableCell.self, forCellReuseIdentifier: MainTableCell.id)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.tableFooterView = UIView()
    
    addSubview(tableView)
    
    tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
}

extension MainCollectionCell:  UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let state = WorkState.allCases[self.section ?? 0]
    return dataSource?.accountGrouper[state].count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableCell.id,
                                                   for: indexPath) as? MainTableCell else {
      return UITableViewCell()
    }
    let state = WorkState.allCases[self.section ?? 0]
    if let account = dataSource?.accountGrouper[state][indexPath.row] {
      cell.configure(with: account)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    175
  }
}
