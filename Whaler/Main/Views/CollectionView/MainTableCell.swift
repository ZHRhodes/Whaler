//
//  MainTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/26/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

class MainTableCell: UITableViewCell {
  static let id = "MainTableCellId"
  private let shadowView = UIView()
  private let containerView = UIView()
  private let nameLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let background = UIView()
    background.backgroundColor = .primaryBackground
    selectedBackgroundView = background
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    configureShadowView()
    configureContainerView()
    configureNameLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with account: Account) {
    configureNameLabel(with: account)
  }
  
  private func configureShadowView() {
    shadowView.backgroundColor = .white
    shadowView.layer.cornerRadius = 16.0
    shadowView.clipsToBounds = false
    shadowView.layer.shadowColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 0.21).cgColor
    shadowView.layer.shadowOpacity = 1.0
    shadowView.layer.shadowRadius = 3.0
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
    
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(shadowView)
    
    shadowView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
    shadowView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
    shadowView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8).isActive = true
    shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
  }
  
  private func configureContainerView() {
    containerView.layer.borderWidth = 2
    containerView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
    containerView.layer.masksToBounds = true
    containerView.layer.cornerRadius = 16.0
    
    shadowView.addAndAttachToEdges(view: containerView)
  }
  
  private func configureNameLabel() {
    nameLabel.font = UIFont.openSans(weight: .regular, size: 25)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(nameLabel)
    
    nameLabel.leftAnchor.constraint(equalTo: shadowView.leftAnchor, constant: 36).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: shadowView.rightAnchor, constant: -12).isActive = true
    nameLabel.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 28).isActive = true
  }
  
  private func configureNameLabel(with account: Account) {
    nameLabel.text = account.name
  }
}
