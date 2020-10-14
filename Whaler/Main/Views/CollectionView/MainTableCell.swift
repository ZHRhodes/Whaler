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

class MainTableCell: UITableViewCell {
  static let id = "MainTableCellId"
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
    configureShadowView()
    configureContainerView()
    configureNameLabel()
    configureAssignedButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with account: Account) {
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
  }
  
  private func configureShadowView() {
    shadowView.backgroundColor = .white
    shadowView.layer.cornerRadius = 12.0
    shadowView.clipsToBounds = false
    
    shadowView.layer.shadowColor = UIColor(red: 116/255, green: 111/255, blue: 146/255, alpha: 0.30).cgColor
    shadowView.layer.shadowOpacity = 1.0
    shadowView.layer.shadowRadius = 15.0
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
    
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(shadowView)
    
    shadowView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
    shadowView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
    shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
    shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
  }
  
  private func configureContainerView() {
    containerView.layer.borderWidth = 2
    containerView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
    containerView.layer.masksToBounds = true
    containerView.layer.cornerRadius = 12.0
    
    shadowView.addAndAttachToEdges(view: containerView)
  }
  
  private func configureNameLabel() {
    nameLabel.font = UIFont.openSans(weight: .regular, size: 24)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(nameLabel)
    
    nameLabel.leftAnchor.constraint(equalTo: shadowView.leftAnchor, constant: 22).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: shadowView.rightAnchor, constant: -12).isActive = true
    nameLabel.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 12).isActive = true
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
  
  private func configureAssignedButton() {
    assignedButton?.removeFromSuperview()
    assignedButton = UIButton()
    let color: UIColor = [.brandGreenDark,
                          .brandPurpleDark,
                          .brandRedDark,
                          .brandYellowDark,
                          .brandPinkDark].randomElement()!
    assignedButton!.backgroundColor = color
    assignedButton!.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
    assignedButton!.layer.cornerRadius = 25
    assignedButton!.translatesAutoresizingMaskIntoConstraints = false
    assignedButton?.setTitle("ZR", for: .normal)
    assignedButton?.titleLabel?.font = .openSans(weight: .regular, size: 18)
    assignedButton?.setTitleColor(.white, for: .normal)
    
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
