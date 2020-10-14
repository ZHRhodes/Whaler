//
//  AccountTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit

class AccountTableCell: UITableViewCell {
  static let id = "AccountTableCellId"
  static let cellHeight = 50.0
  
  private let shadowView = UIView()
  private let moveDotsImageContainer = UIView()
  private var stackView: UIStackView!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let background = UIView()
    background.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
    selectedBackgroundView = background
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with account: Account) {
    configureShadowView()
    configureMoveDots()
    configureStackView(with: account)
  }
  
  private func configureShadowView() {
    shadowView.backgroundColor = .white
    shadowView.clipsToBounds = false
    shadowView.layer.shadowColor = UIColor(red: 116/255, green: 111/255, blue: 146/255, alpha: 0.30).cgColor
    shadowView.layer.shadowOpacity = 1.0
    shadowView.layer.shadowRadius = 15.0
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
    
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(shadowView)
    
    shadowView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
    shadowView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
    shadowView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5).isActive = true
    shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
  }
  
  private func configureMoveDots() {
    contentView.addSubview(moveDotsImageContainer)
    moveDotsImageContainer.translatesAutoresizingMaskIntoConstraints = false
    moveDotsImageContainer.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true
    moveDotsImageContainer.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
    moveDotsImageContainer.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
    moveDotsImageContainer.widthAnchor.constraint(equalToConstant: 36).isActive = true

    let moveDotsImage = UIImageView(image: UIImage(named: "moveDots"))
    moveDotsImageContainer.addSubview(moveDotsImage)
    moveDotsImage.translatesAutoresizingMaskIntoConstraints = false
    moveDotsImage.centerXAnchor.constraint(equalTo: moveDotsImageContainer.centerXAnchor).isActive = true
    moveDotsImage.centerYAnchor.constraint(equalTo: moveDotsImageContainer.centerYAnchor).isActive = true
    moveDotsImage.widthAnchor.constraint(equalToConstant: 7.2).isActive = true
    moveDotsImage.heightAnchor.constraint(equalToConstant: 12).isActive = true
  }
  
  private func configureStackView(with account: Account) {
    stackView?.removeFromSuperview()
    stackView = UIStackView()
    let valuesToShow = [\Account.name,
                        \Account.contactsCount,
                        \Account.industry,
                        \Account.billingCity,
                        \Account.billingState]
    valuesToShow.forEach { path in
      let text = account[keyPath: path] as? String
      stackView.addArrangedSubview(makeColumn(text: text))
    }
    shadowView.addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillEqually
  
    stackView.leftAnchor.constraint(equalTo: moveDotsImageContainer.rightAnchor).isActive = true
    stackView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true
    stackView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
  }
  
  private func makeColumn(text: String?) -> UIView {
    let label = UILabel()
    label.font = UIFont.openSans(weight: .regular, size: 17)
    if let text = text {
      label.text = text
      label.textColor = .black
    } else {
      label.text = "—"
      label.textColor = .lightText
    }

    return label
  }
}
