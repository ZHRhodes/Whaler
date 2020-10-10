//
//  MainCollectionCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/26/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

protocol MainCollectionCellDelegate: class {
  func didSelectRowAt(section: Int, didSelectRowAt indexPath: IndexPath)
  func didClickAssignButton(_ button: UIButton, forAccount account: Account)
}

class MainCollectionCell: UICollectionViewCell {
  static let id = "MainCollectionCellId"
  
  weak var delegate: MainCollectionCellDelegate?
  private var headerView: UIView?
  private let tableView = UITableView()
  var section: Int? {
    didSet {
      headerView?.removeFromSuperview()
      configureHeaderView()
    }
  }
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
    backgroundColor = .primaryBackground
    tableView.dragInteractionEnabled = true
    tableView.dragDelegate = self
    tableView.dropDelegate = self
    configureHeaderView()
    configureTableView()
//    let cover = UIView()
//    cover.backgroundColor = .orange
//    addAndAttachToEdges(view: cover)
  }
  
  private func configureHeaderView() {
    headerView = UIView()
    headerView!.translatesAutoresizingMaskIntoConstraints = false
    headerView!.backgroundColor = .clear
    addSubview(headerView!)
    
    headerView!.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
    headerView!.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    headerView!.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
    headerView!.heightAnchor.constraint(equalToConstant: AccountStateTagView.height+10).isActive = true
    
    headerView!.addAndAttachToEdges(view: AccountStateTagView(state: WorkState.allCases[section ?? 0]))
  }
  
  private func configureTableView() {
    tableView.backgroundColor = .primaryBackground
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(MainTableCell.self, forCellReuseIdentifier: MainTableCell.id)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.tableFooterView = UIView()
    
    addSubview(tableView)
    
    tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: topAnchor, constant: AccountStateTagView.height+20).isActive = true
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
    cell.delegate = self
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let section = section else { return }
    delegate?.didSelectRowAt(section: section, didSelectRowAt: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    175
  }
}

extension MainCollectionCell: UITableViewDragDelegate {
  func tableView(_ tableView: UITableView,
                 itemsForBeginning session: UIDragSession,
                 at indexPath: IndexPath) -> [UIDragItem] {
    let state = WorkState.allCases[self.section ?? 0]
    guard let account = dataSource?.accountGrouper[state][indexPath.row] else { return [] }
    let itemProvider = NSItemProvider(object: account)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    dragItem.previewProvider = { () -> UIDragPreview? in
//      let cell = tableView.cellForRow(at: indexPath)
//      cell?.layer.opacity = 0.0
//      return UIDragPreview(view: cell!)
      print("PREVIEW BEING CALLED ------------------------------------------------------")
      return nil
    }
    session.localContext = (dataSource, state, indexPath, tableView)
    return [dragItem]
  }
  
//  func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//    let previewParameters = UIDragPreviewParameters()
//    previewParameters.visiblePath = UIBezierPath(roundedRect: CGRect(x: 5, y: 8, width: yourWidth, height: yourHeight), cornerRadius: yourRadius)
//    return previewParameters
//  }
}

extension MainCollectionCell: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
      for item in coordinator.items {
//        guard let sourceIndexPath = item.sourceIndexPath else { continue }
        item.dragItem.itemProvider.loadObject(ofClass: Account.self) { (object, error) in
          guard let account = object as? Account else { return }
          var updatedIndexPaths = [IndexPath]()
          
          switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
          case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
          // Same Table View
            if sourceIndexPath.row < destinationIndexPath.row {
              updatedIndexPaths = (sourceIndexPath.row...destinationIndexPath.row).map { IndexPath(row: $0, section: 0) }
            } else if sourceIndexPath.row > destinationIndexPath.row {
              updatedIndexPaths = (destinationIndexPath.row...sourceIndexPath.row).map { IndexPath(row: $0, section: 0) }
            }
            DispatchQueue.main.async {
              self.tableView.beginUpdates()
              let state = WorkState.allCases[self.section ?? 0]
              if let removedAccoount = self.dataSource?.accountGrouper.remove(from: state, at: sourceIndexPath.row) {
                self.dataSource?.accountGrouper.insert(removedAccoount, to: state, at: destinationIndexPath.row)
              }
              self.tableView.reloadRows(at: updatedIndexPaths, with: .fade)
              self.tableView.endUpdates()
            }
          case (nil, .some(let destinationIndexPath)):
            // Move data from a table to another table
            DispatchQueue.main.async {
              self.tableView.beginUpdates()
              self.removeSourceTableData(localContext: coordinator.session.localDragSession?.localContext)
              let state = WorkState.allCases[self.section ?? 0]
              self.dataSource?.accountGrouper.insert(account, to: state, at: destinationIndexPath.row)
              self.tableView.insertRows(at: [destinationIndexPath], with: .fade)
              self.tableView.endUpdates()
            }
          case (nil, nil):
            // Insert data from a table to another table
            DispatchQueue.main.async {
              self.tableView.beginUpdates()
              self.removeSourceTableData(localContext: coordinator.session.localDragSession?.localContext)
              let state = WorkState.allCases[self.section ?? 0]
              self.dataSource?.accountGrouper.append(account, to: state)
              let count = self.dataSource?.accountGrouper[state].count ?? 1
              self.tableView.insertRows(at: [IndexPath(row: count - 1, section: 0)], with: .fade)
              self.tableView.endUpdates()
            }
          default: break
        }
      }
    }
  }
  
  func removeSourceTableData(localContext: Any?) {
    guard let (dataSource, state, sourceIndexPath, tableView) = localContext as? (MainInteractorData, WorkState, IndexPath, UITableView) else { return }
    dataSource.accountGrouper.remove(from: state, at: sourceIndexPath.row)
    tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
  }
    
  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
      return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
}

extension MainCollectionCell: MainTableCellDelegate {
  func didClickAssignButton(_ button: UIButton, forAccount account: Account) {
    delegate?.didClickAssignButton(button, forAccount: account)
  }
}
