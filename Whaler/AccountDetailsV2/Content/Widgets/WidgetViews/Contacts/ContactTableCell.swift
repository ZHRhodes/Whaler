//
//  ContactTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

protocol ContactTableCellDelegate: class {
  func didClickAssignButton(_ button: UIButton, forContact contact: Contact)
}

class ContactTableCell: UITableViewCell, TableInCollectionViewTableCell {
  static var id: String = "ContactTableCellId"
  static let cellHeight: CGFloat = 113.0
  
  weak var delegate: ContactTableCellDelegate?
  private let shadowView = UIView()
  private let containerView = UIView()
  private var contact: Contact!
  private let nameLabel = UILabel()
  private let jobTitleLabel = UILabel()
  private var assignedButton = AssignedButton(frame: .zero)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let background = UIView()
    background.backgroundColor = .primaryBackground
    selectedBackgroundView = background
    selectionStyle = .none
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    contentView.isSkeletonable = true
    isSkeletonable = true
    configureShadowView()
    configureContainerView()
    configureAssignedButton()
    configureNameLabel()
    configureJobTitleLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    hideSkeleton()
    assignedButton.reset()
  }
  
  private func configureShadowView() {
    shadowView.backgroundColor = .cellBackground
    shadowView.layer.cornerRadius = 12.0
    shadowView.clipsToBounds = false
    shadowView.isSkeletonable = true
    
    shadowView.layer.shadowColor = UIColor.cellShadow.cgColor
    shadowView.layer.shadowOpacity = 1.0
    shadowView.layer.shadowRadius = 5.0
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
    
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(shadowView)
    
    shadowView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4).isActive = true
    shadowView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4).isActive = true
    shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
  }
  
  private func configureContainerView() {
    containerView.layer.masksToBounds = true
    containerView.layer.cornerRadius = 12.0
    containerView.isSkeletonable = true
    
    shadowView.addAndAttachToEdges(view: containerView)
  }
  
  func configure<T>(with object: T) {
    guard let contact = object as? Contact else {
      let message = "Fatal error! Configuring cell with wrong type."
      Log.error(message)
      fatalError(message)
    }
    self.contact = contact
    nameLabel.text = contact.fullName
    jobTitleLabel.text = contact.jobTitle
    let assignedTo = Lifecycle.currentUser?.organization?.users.first(where: { $0.id == contact.assignedTo })
    if let assignedTo = assignedTo {
      assignedButton.assigned(assignedTo)
    }
  }
  
  func setDelegate<D>(_ delegate: D) {
    self.delegate = delegate as? ContactTableCellDelegate
  }
  
  private func configureNameLabel() {
    nameLabel.font = .openSans(weight: .regular, size: 24)
    nameLabel.isSkeletonable = true
    
    if nameLabel.superview == nil {
      nameLabel.translatesAutoresizingMaskIntoConstraints = false
      containerView.addSubview(nameLabel)
      
      nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 21).isActive = true
      nameLabel.rightAnchor.constraint(equalTo: assignedButton.leftAnchor, constant: -12).isActive = true
      nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
      nameLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
    }
  }
  
  private func configureJobTitleLabel() {
    jobTitleLabel.font = .openSans(weight: .regular, size: 18)
    jobTitleLabel.textColor = .secondaryText
    jobTitleLabel.isSkeletonable = true
    
    if jobTitleLabel.superview == nil {
      jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
      containerView.addSubview(jobTitleLabel)
      
      jobTitleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 21).isActive = true
      jobTitleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6).isActive = true
      jobTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -13).isActive = true
      jobTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
  }
  
  private func configureAssignedButton() {
    assignedButton.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
    assignedButton.setSize(38)
    assignedButton.titleLabel?.font = .openSans(weight: .semibold, size: 14)
    containerView.addAndAttach(view: assignedButton, attachingEdges: [.right(-24),
                                                                      .centerY()])
  }
  
  @objc
  private func assignButtonTapped() {
    delegate?.didClickAssignButton(assignedButton, forContact: contact)
  }
}
