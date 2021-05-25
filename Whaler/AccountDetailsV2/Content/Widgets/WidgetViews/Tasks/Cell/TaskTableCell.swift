//
//  TaskTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class TaskTableCell: UITableViewCell {
  static var id: String = "TaskTableCellId"
  static let cellHeight: CGFloat = 72.0
  
  private let doneButton = UIButton()
  private let contentContainer = UIView()
  private let descriptionLabel = UILabel()
  private var typeTag: UIView?
  private var dueDateTag: UIView?
  private var assignedButton = AssignedButton()
  private let dotsButton = UIButton()
  
  private var task: Task!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.isSkeletonable = true
    backgroundColor = .clear
    isSkeletonable = true
    configureDoneButton()
    configureContentContainer()
    configureDescriptionLabel()
    configureTypeTagIfNecessary()
    configureDueDateTagIfNecessary()
    configureAssignedButton()
    configureDotsButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  func configure(with task: Task) {
    self.task = task
    setValues(using: task)
  }
  
  func setValues(using task: Task) {
    descriptionLabel.text = task.description
  }
  
  private func configureDoneButton() {
    let size: CGFloat = 27.0
    doneButton.backgroundColor = .borderLineColor
    doneButton.layer.cornerRadius = size/2
    
    contentView.addAndAttach(view: doneButton,
                             height: size,
                             width: size,
                             attachingEdges: [.left(20), .centerY(0)])
  }
  
  private func configureContentContainer() {
    contentContainer.backgroundColor = .cellBackground
    contentContainer.layer.cornerRadius = UIConstants.boxCornerRadius
    
    contentView.addAndAttach(view: contentContainer, attachingEdges: [.left(20, equalTo: doneButton.rightAnchor),
                                                                      .top(8),
                                                                      .bottom(-8),
                                                                      .right(-20)])
  }
  
  private func configureDescriptionLabel() {
    descriptionLabel.font = .openSans(weight: .regular, size: 18)
    
    contentContainer.addAndAttach(view: descriptionLabel,
                                  height: 25,
                                  attachingEdges: [.left(20), .centerY()])
  }
  
  private func configureTypeTagIfNecessary() {
    
  }
  
  private func configureDueDateTagIfNecessary() {
    
  }
  
  private func configureAssignedButton() {
    
  }
  
  private func configureDotsButton() {
    
  }
}
