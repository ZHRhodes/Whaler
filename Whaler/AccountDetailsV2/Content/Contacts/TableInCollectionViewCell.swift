//
//  TableInCollectionViewCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

protocol SectionInfoProviding {
  var title: String { get }
  var color: UIColor { get }
}

protocol TableInCollectionViewTableCell {
  static var id: String { get }
  static var cellHeight: CGFloat { get }
  func configure<T>(with object: T)
}

protocol TableInCollectionViewDelegate: class {
  func didSelectItemAt(section: String, row: Int)
}

protocol TableInCollectionViewDataSource {
  
}

class TableInCollectionViewCell<TableCell: UITableViewCell & TableInCollectionViewTableCell, TableCellData>:
  UICollectionViewCell,
  UITableViewDelegate,
  SkeletonTableViewDataSource {
  
  static func id() -> String {
    return "TableInCollectionViewCellId"
  }
  
  weak var delegate: TableInCollectionViewDelegate?
  private var headerView: UIView?
  private let tableView = UITableView()
  private var didShowInitialLoad = false
  
  private var dataSource = [TableCellData]() {
    didSet {
      tableView.reloadData()
    }
  }
  private var sectionInfo: SectionInfoProviding? {
    didSet {
      guard let sectionInfo = sectionInfo else { return }
      headerView?.removeFromSuperview()
      configureHeaderView(with: sectionInfo)
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
  
  func configure(sectionInfo: SectionInfoProviding, dataSource: [TableCellData]?) {
    if let dataSource = dataSource {
      self.dataSource = dataSource
      tableView.hideSkeleton()
    }
    self.sectionInfo = sectionInfo
  }
  
  private func configure() {
    layer.masksToBounds = true
    layer.cornerRadius = 10.0
    backgroundColor = .primaryBackground
    isSkeletonable = true
    configureTableView()
    tableView.showAnimatedGradientSkeleton()
  }
  
  private func configureTableView() {
//    tableView.dragInteractionEnabled = true
//    tableView.dragDelegate = self
//    tableView.dropDelegate = self
    tableView.backgroundColor = .primaryBackground
    tableView.layer.cornerRadius = 10.0
    tableView.clipsToBounds = true
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.id)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.tableFooterView = UIView()
    tableView.isSkeletonable = true
    
    addSubview(tableView)
    
    tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: topAnchor, constant: MainCollectionCellHeader.height + 20).isActive = true
    tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  private func configureHeaderView(with sectionInfo: SectionInfoProviding) {
    headerView = UIView()
    headerView!.translatesAutoresizingMaskIntoConstraints = false
    headerView!.backgroundColor = .clear
    addSubview(headerView!)
    
    headerView!.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
    headerView!.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    headerView!.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
    headerView!.heightAnchor.constraint(equalToConstant: MainCollectionCellHeader.height).isActive = true
    
    let view = MainCollectionCellHeader(text: sectionInfo.title, colors: [sectionInfo.color, sectionInfo.color])
    headerView!.addAndAttachToEdges(view: view)
  }
  
  //UITableViewDelegate, UITableViewDataSource
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return TableCell.id
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count //this is getting called a gazillion times
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.id, for: indexPath) as? TableCell else {
      return UITableViewCell()
    }
    
    let item = dataSource[indexPath.row]
    cell.configure(with: item)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let sectionInfo = sectionInfo else { return }
    delegate?.didSelectItemAt(section: sectionInfo.title, row: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return TableCell.cellHeight
  }
}
