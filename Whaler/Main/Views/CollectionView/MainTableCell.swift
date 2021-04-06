//
//  MainTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/26/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

protocol MainTableCellDelegate: class {
  func didClickAssignButton(_ button: UIButton, forAccount account: Account)
}

class MainTableCell: UITableViewCell, MainCollectionTableCell {
  static let id = "MainTableCellId"
  static let cellHeight: CGFloat = 150.0
  weak var delegate: MainTableCellDelegate?
  private let shadowView = UIView()
  private let containerView = UIView()
  private let nameLabel = UILabel()
  private var attributesStack: UIStackView?
  private var assignedButton: UIButton?
  private var account: Account?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let background = UIView()
    background.backgroundColor = .primaryBackground
    selectedBackgroundView = background
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    contentView.clipsToBounds = false
    isSkeletonable = true
    configureShadowView()
    configureContainerView()
    configureNameLabel()
    configureAssignedButton()
    configureAttributesCover()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    assignedButton?.backgroundColor = .secondaryText
    assignedButton?.setTitle("—", for: .normal)
  }
  
  func configure<T>(with object: T, assignedTo: NameAndColorProviding?) {
    guard let account = object as? Account else {
      let message = "Fatal error! Configuring cell with wrong type."
      Log.error(message)
      fatalError(message)
    }
    hideSkeleton()
    self.account = account
    configureNameLabel(with: account)
    var attributes = [Attribute]()
    if let industry = account.industry {
      attributes.append(Attribute(text: industry, foregroundColor: .lightText, backgroundColor: .clear, borderColor: .lightText))
    }
    
    if let billingState = account.billingState {
      attributes.append(Attribute(text: billingState, foregroundColor: .lightText, backgroundColor: .clear, borderColor: .lightText))
    }
    configureAttributeTags(attributes: attributes)
    if let assignedTo = assignedTo {
      assignedButton?.setTitle(assignedTo.initials, for: .normal)
      assignedButton?.backgroundColor = assignedTo.color
    }
  }
  
  private func configureShadowView() {
    shadowView.isSkeletonable = true
    shadowView.backgroundColor = .cellBackground
    shadowView.layer.cornerRadius = 12.0
    shadowView.clipsToBounds = false
    
    shadowView.layer.shadowColor = UIColor.cellShadow.cgColor
    shadowView.layer.shadowOpacity = 1.0
    shadowView.layer.shadowRadius = 5.0
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
    
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(shadowView)
    
    shadowView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
    shadowView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -0).isActive = true
    shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
    shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
  }
  
  private func configureContainerView() {
    containerView.layer.masksToBounds = true
    containerView.layer.cornerRadius = 12.0
    containerView.isSkeletonable = true
    
    shadowView.addAndAttachToEdges(view: containerView)
  }
  
  private func configureNameLabel() {
    nameLabel.font = UIFont.openSans(weight: .regular, size: 24)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.layer.cornerRadius = 10.0
    nameLabel.isSkeletonable = true
    nameLabel.skeletonCornerRadius = 8.0
    
    containerView.addSubview(nameLabel)
    
    nameLabel.leftAnchor.constraint(equalTo: shadowView.leftAnchor, constant: 22).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: shadowView.rightAnchor, constant: -22).isActive = true
    nameLabel.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 12).isActive = true
    nameLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
  }
  
  private func configureNameLabel(with account: Account) {
    nameLabel.text = account.name
  }
  
  private func configureAttributeTags(attributes: [Attribute]) {
    attributesStack?.removeFromSuperview()
    attributesStack = UIStackView()
    attributesStack!.axis = .horizontal
    attributesStack?.spacing = 6.0
//    attributesStack?.distribution = .equalSpacing
    attributesStack?.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(attributesStack!)
    
    attributesStack!.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 22).isActive = true
    attributesStack!.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -18).isActive = true
    attributesStack!.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor, constant: -12).isActive = true
//    attributesStack!.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
//    attributesStack!.leftAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
    
    for attribute in attributes {
      let tagView = AttributeTagView(attribute: attribute)
      tagView.setContentHuggingPriority(.required, for: .horizontal)
      attributesStack?.addArrangedSubview(tagView)
    }
    
    attributesStack?.addArrangedSubview(UIView())
  }
  
  private func configureAttributesCover() {
    let cover = UIView()
    cover.translatesAutoresizingMaskIntoConstraints = false
    cover.isSkeletonable = true
    
    containerView.addSubview(cover)
    cover.leftAnchor.constraint(equalTo: leftAnchor, constant: 22).isActive = true
    cover.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30).isActive = true
    cover.heightAnchor.constraint(equalToConstant: 33).isActive = true
    cover.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
  }
  
  private func configureAssignedButton() {
    assignedButton?.removeFromSuperview()
    assignedButton = UIButton()
    if assignedButton?.backgroundColor == nil {
      assignedButton!.backgroundColor = .secondaryText
    }
    assignedButton!.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
    assignedButton!.layer.cornerRadius = 25
    assignedButton!.translatesAutoresizingMaskIntoConstraints = false
    assignedButton!.setTitle("—", for: .normal)
    assignedButton!.titleLabel?.font = .openSans(weight: .bold, size: 18)
    assignedButton!.setTitleColor(.white, for: .normal)
    assignedButton!.isSkeletonable = true
    assignedButton?.skeletonCornerRadius = 25.0
    
    containerView.addSubview(assignedButton!)
    
    assignedButton!.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -22).isActive = true
    assignedButton!.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -22).isActive = true
    assignedButton!.widthAnchor.constraint(equalToConstant: 50).isActive = true
    assignedButton!.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
  @objc
  private func assignButtonTapped() {
    guard let delegate = delegate,
          let assignedButton = assignedButton,
          let account = account else { return }
    delegate.didClickAssignButton(assignedButton, forAccount: account)
  }
}
