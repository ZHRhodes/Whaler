//
//  TaskTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit
import Combine

protocol TaskTableCellDelegate: AnyObject {
  func changedDescription(new: String, forTask task: Task)
  func changedDate(newDate: Date, forTask task: Task)
	func didClickAssignButton(_ button: UIButton, forTask task: Task)
}

class TaskTableCell: UITableViewCell {
  static var id: String = "TaskTableCellId"
  static let cellHeight: CGFloat = 72.0
  
  weak var delegate: TaskTableCellDelegate?
  
  private let doneButton = CircleCheckbox(frame: .zero)
  private let contentContainer = UIView()
  private let descriptionTextField = UITextField()
  private var typeTag = UIButton()
  private var dueDateTag = UIButton()
  private var datePicker = UIDatePicker()
  private var assignedButton = AssignedButton()
  private let dotsButton = UIButton()
  
  private let descriptionChangePublisher = PassthroughSubject<String, Never>()
  private var descriptionChangeCancellable: AnyCancellable?
  
  private var task: Task!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.isSkeletonable = true
    backgroundColor = .clear
    selectionStyle = .none
    isSkeletonable = true
    configureDoneButton()
    configureContentContainer()
    configureDotsButton()
    configureAssignedButton()
    configureDueDateTag()
    configureTypeTag()
    configureDescriptionTextField()
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
    descriptionTextField.text = task.description
    typeTag.setTitle(task.type, for: .normal)
    setDate(task.dueDate ?? Date())
    if let assignedTo = Lifecycle.currentUser?.organization?.users.first(where: { $0.id == task.assignedTo }) {
      assignedButton.assigned(assignedTo)
    }
  }
  
  func setDate(_ date: Date) {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd"
    let formattedDate = formatter.string(from: date)
    dueDateTag.setTitle(formattedDate, for: .normal)
    
    datePicker.date = date
  }
  
  private func configureDoneButton() {
    doneButton.addTarget(self, action: #selector(doneToggled), for: .touchUpInside)
    let size: CGFloat = 27.0
    contentView.addAndAttach(view: doneButton,
                             attachingEdges: [.left(20), .centerY(0)])
    doneButton.setSize(size)
  }
  
  private func configureContentContainer() {
    contentContainer.backgroundColor = .cellBackground
    contentContainer.layer.cornerRadius = UIConstants.boxCornerRadius
    contentContainer.layer.borderWidth = UIConstants.boxBorderWidth
    contentContainer.layer.borderColor = UIColor.cellShadow.cgColor
    
    contentView.addAndAttach(view: contentContainer, attachingEdges: [.left(20, equalTo: doneButton.rightAnchor),
                                                                      .top(8),
                                                                      .bottom(-8),
                                                                      .right(-20)])
  }
  
  private func configureDotsButton() {
    dotsButton.setImage(UIImage(named: "tripleDots"), for: .normal)
    dotsButton.tintColor = .primaryText
    
    contentContainer.addAndAttach(view: dotsButton, height: 15, width: 15, attachingEdges: [
      .centerY(), .right(-16)
    ])
  }
  
  private func configureAssignedButton() {
    assignedButton.titleLabel?.font = .openSans(weight: .semibold, size: 14)
		assignedButton.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
    assignedButton.setSize(38)
    contentContainer.addAndAttach(view: assignedButton, attachingEdges: [
      .centerY(), .right(-20, equalTo: dotsButton.leftAnchor)
    ])
  }
  
  private func configureDueDateTag() {
    let container = UIView()
    container.backgroundColor = .accentBackground
    container.layer.cornerRadius = UIConstants.boxCornerRadius
    container.clipsToBounds = true
    
    dueDateTag.backgroundColor = .accentBackground
    dueDateTag.isUserInteractionEnabled = false
    dueDateTag.setTitleColor(.brandGreenDark, for: .normal)
    dueDateTag.titleLabel?.font = .openSans(weight: .semibold, size: 18)
    dueDateTag.setContentHuggingPriority(.required, for: .horizontal)
    
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .compact
    datePicker.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
  
    container.addAndAttach(view: datePicker, attachingEdges: [
      .centerY(), .left()
    ])
    
    let pickerCover = UIView()
    pickerCover.backgroundColor = .accentBackground
    pickerCover.isUserInteractionEnabled = false
    
    container.addAndAttachToEdges(view: pickerCover)
    
    container.addAndAttach(view: dueDateTag, attachingEdges: [
      .centerY(), .left(8), .right(-8)
    ])
    
    contentContainer.addAndAttach(view: container, height: 38, attachingEdges: [
      .centerY(), .right(-34, equalTo: assignedButton.leftAnchor)
    ])
  }
  
  private func configureTypeTag() {
    let container = UIView()
    container.backgroundColor = .accentBackground
    container.layer.cornerRadius = UIConstants.boxCornerRadius
    
    container.addAndAttach(view: typeTag, attachingEdges: [
      .top(), .bottom(), .left(10), .right(-10)
    ])
    
    typeTag.setTitleColor(.brandPurple, for: .normal)
    typeTag.titleLabel?.font = .openSans(weight: .semibold, size: 18)
    typeTag.setContentHuggingPriority(.required, for: .horizontal)
    
    contentContainer.addAndAttach(view: container, height: 38, attachingEdges: [
      .centerY(), .right(-34, equalTo: dueDateTag.leftAnchor)
    ])
  }
  
  private func configureDescriptionTextField() {
    descriptionTextField.font = .openSans(weight: .regular, size: 18)
    descriptionTextField.addTarget(self, action: #selector(descriptionChanged), for: .editingChanged)
    descriptionChangeCancellable = descriptionChangePublisher
      .debounce(for: .seconds(0.75), scheduler: DispatchQueue.main)
      .sink { [weak self] (newValue) in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.changedDescription(new: newValue, forTask: strongSelf.task)
    }
    
    contentContainer.addAndAttach(view: descriptionTextField,
                                  height: 25,
                                  attachingEdges: [
                                    .left(20), .right(-20, equalTo: typeTag.leftAnchor), .centerY()
                                  ])
  }
  
  @objc
  private func descriptionChanged() {
    descriptionTextField.text.map { descriptionChangePublisher.send($0) }
  }
  
  @objc
  func doneToggled() {
    doneButton.toggle()
  }
  
  @objc
  func dateSelected(sender: UIDatePicker, forEvent event: UIEvent) {
    setDate(sender.date)
    delegate?.changedDate(newDate: sender.date, forTask: task)
  }
	
	@objc
	func assignButtonTapped() {
		delegate?.didClickAssignButton(assignedButton, forTask: task)
	}
}
