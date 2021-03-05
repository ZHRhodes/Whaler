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
  func requestChangeToData<ObjectType>(adding: ObjectType, index: Int, sectionTitle: String)
  func requestChangeToData(removingFrom index: Int, sectionTitle: String)
}

typealias NSItemProviderReadingWriting = NSItemProviderReading & NSItemProviderWriting

class TableInCollectionViewCell<TableCell: UITableViewCell & TableInCollectionViewTableCell,
                                TableCellData: NSItemProviderReadingWriting>:
  UICollectionViewCell,
  UITableViewDelegate,
  SkeletonTableViewDataSource,
  UITableViewDragDelegate,
  UITableViewDropDelegate {
  
  static func id() -> String {
    return "TableInCollectionViewCellId"
  }
  
  weak var delegate: TableInCollectionViewDelegate?
  private var headerView: UIView?
  private let tableView = UITableView()
  private var didShowInitialLoad = false
  private var setNeedsHideSkeleton = false
  private var setNeedsShowSkeleton = false
  
  var dataSource = [TableCellData]()
  
  private(set) var sectionInfo: SectionInfoProviding? {
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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if setNeedsHideSkeleton {
      tableView.hideSkeleton()
      setNeedsHideSkeleton.toggle()
    }
    
    if setNeedsShowSkeleton {
      tableView.showAnimatedGradientSkeleton()
      setNeedsShowSkeleton.toggle()
    }
  }
  
  func configure(sectionInfo: SectionInfoProviding, dataSource: [TableCellData], delegate: TableInCollectionViewDelegate, showSkeleton: Bool) {
    self.dataSource = dataSource
    self.sectionInfo = sectionInfo
    self.delegate = delegate
    if showSkeleton {
      setNeedsShowSkeleton = true
    } else {
      setNeedsHideSkeleton = true
    }
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
    tableView.dragInteractionEnabled = true
    tableView.dragDelegate = self
    tableView.dropDelegate = self
    tableView.backgroundColor = .primaryBackground
    tableView.layer.cornerRadius = 10.0
    tableView.clipsToBounds = true
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.id)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.tableFooterView = UIView()
    tableView.isSkeletonable = true
    
    contentView.addSubview(tableView)
    
    tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: MainCollectionCellHeader.height + 20).isActive = true
    tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  }
  
  private func configureHeaderView(with sectionInfo: SectionInfoProviding) {
    headerView = UIView()
    headerView!.translatesAutoresizingMaskIntoConstraints = false
    headerView!.backgroundColor = .clear
    contentView.addSubview(headerView!)
    
    headerView!.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
    headerView!.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    headerView!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
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
  
  //UITableViewDragDelegate, UITableViewDrogDelegate
  func tableView(_ tableView: UITableView,
                 itemsForBeginning session: UIDragSession,
                 at indexPath: IndexPath) -> [UIDragItem] {
    let object = dataSource[indexPath.row]
    let itemProvider = NSItemProvider(object: object)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    session.localContext = (object, sectionInfo?.title ?? "", indexPath, tableView)
    return [dragItem]
  }
  
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    for item in coordinator.items {
      item.dragItem.itemProvider.loadObject(ofClass: TableCellData.self) { (object, error) in
        guard let context = coordinator.session.localDragSession?.localContext as? (TableCellData, String, IndexPath, UITableView) else { return }
        let object = context.0
        
        switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
        case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
          DispatchQueue.main.async {
            self.delegate?.requestChangeToData(removingFrom: sourceIndexPath.row, sectionTitle: self.sectionInfo?.title ?? "")
            self.delegate?.requestChangeToData(adding: object, index: destinationIndexPath.row, sectionTitle: self.sectionInfo?.title ?? "")
            let rowsToUpdate = self.rowsToUpdate(movingFrom: sourceIndexPath, to: destinationIndexPath)
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: rowsToUpdate, with: .fade)
            self.tableView.endUpdates()
          }
        //Dragging between rows in a different table
        case (nil, .some(let destinationIndexPath)):
          DispatchQueue.main.async {
            self.removeSourceTableData(localContext: context)
            self.delegate?.requestChangeToData(adding: object, index: destinationIndexPath.row, sectionTitle: self.sectionInfo?.title ?? "")
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [destinationIndexPath], with: .fade)
            self.tableView.endUpdates()
          }
        //Dragging past the last cell
        case (nil, nil):
          DispatchQueue.main.sync {
            self.removeSourceTableData(localContext: context)
            self.delegate?.requestChangeToData(adding: object, index: self.dataSource.endIndex, sectionTitle: self.sectionInfo?.title ?? "")
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)], with: .fade)
            self.tableView.endUpdates()
          }
        default:
          break
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
      return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
  
  func removeSourceTableData(localContext: Any?) {
    guard let (_, sectionTitle, indexPath, tableView) = localContext as? (TableCellData, String, IndexPath, UITableView) else { return }
    delegate?.requestChangeToData(removingFrom: indexPath.row, sectionTitle: sectionTitle)
    tableView.deleteRows(at: [indexPath], with: .fade)
  }
  
  func rowsToUpdate(movingFrom sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) -> [IndexPath] {
    if sourceIndexPath.row < destinationIndexPath.row {
      return (sourceIndexPath.row...destinationIndexPath.row).map { IndexPath(row: $0, section: 0) }
    } else if sourceIndexPath.row > destinationIndexPath.row {
      return (destinationIndexPath.row...sourceIndexPath.row).map { IndexPath(row: $0, section: 0) }
    } else {
      return []
    }
  }
}
