//
//  ContactTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class ContactTableCell: UITableViewCell, TableInCollectionViewTableCell {
  static var id: String = "ContactTableCellId"
  static let cellHeight: CGFloat = 113.0
  
  private let shadowView = UIView()
  private let containerView = UIView()
  private var contact: Contact!
  private let nameLabel = UILabel()
  private let jobTitleLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let background = UIView()
    background.backgroundColor = .primaryBackground
    selectedBackgroundView = background
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    contentView.isSkeletonable = true
    isSkeletonable = true
    configureShadowView()
    configureContainerView()
    configureNameLabel()
    configureJobTitleLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    hideSkeleton()
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
  }
  
  private func configureNameLabel() {
    nameLabel.font = .openSans(weight: .regular, size: 24)
    nameLabel.isSkeletonable = true
    
    if nameLabel.superview == nil {
      nameLabel.translatesAutoresizingMaskIntoConstraints = false
      containerView.addSubview(nameLabel)
      
      nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 21).isActive = true
      nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -21).isActive = true
      nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 13).isActive = true
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
}

