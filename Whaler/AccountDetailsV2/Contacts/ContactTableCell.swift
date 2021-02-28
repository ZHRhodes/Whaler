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
    configureShadowView()
    configureContainerView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureShadowView() {
    shadowView.backgroundColor = .cellBackground
    shadowView.layer.cornerRadius = 12.0
    shadowView.clipsToBounds = false
    
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
    
    shadowView.addAndAttachToEdges(view: containerView)
  }
  
  func configure<T>(with object: T) {
    guard let contact = object as? Contact else {
      let message = "Fatal error! Configuring cell with wrong type."
      Log.error(message)
      fatalError(message)
    }
    self.contact = contact
    configureNameLabel()
    configureJobTitleLabel()
  }
  
  private func configureNameLabel() {
    nameLabel.text = contact.fullName
    nameLabel.font = .openSans(weight: .regular, size: 24)
    
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
    jobTitleLabel.text = contact.jobTitle
    jobTitleLabel.font = .openSans(weight: .regular, size: 18)
    jobTitleLabel.textColor = .secondaryText
    
    if jobTitleLabel.superview == nil {
      jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
      containerView.addSubview(jobTitleLabel)
      
      jobTitleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 21).isActive = true
      jobTitleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -21).isActive = true
      jobTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -13).isActive = true
      jobTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
  }
}


