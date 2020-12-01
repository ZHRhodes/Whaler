//
//  ContactRowView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftUI

protocol ContactRowViewDelegate: class {
  func didClickAssignButton(_ button: UIView, forContact contact: Contact)
}

class ContactRowView: UIView {
  weak var delegate: ContactRowViewDelegate?
  private let shadowView = UIView()
  private var stackView: UIStackView!
  private let moveDotsImageContainer = UIView()
  private let assignButton = UIButton()
  private var contact: Contact?
  
  init() {
    super.init(frame: .zero)
    configureShadowView()
    configureMoveDots()
    configureAssignButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with contact: Contact) {
    self.contact = contact
    configureStackView(with: contact)
  }
  
  private func configureShadowView() {
    //if we actually go with the line, clean up and rename this, etc
    shadowView.layer.cornerRadius = 10
    shadowView.layer.masksToBounds = true
    shadowView.layer.borderWidth = 1.0
    shadowView.layer.borderColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 0.75).cgColor
    
//    shadowView.backgroundColor = .white
//    shadowView.clipsToBounds = false
//    shadowView.layer.shadowColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 0.21).cgColor
//    shadowView.layer.shadowOpacity = 1.0
//    shadowView.layer.shadowRadius = 6.0
//    shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
//
    shadowView.clipsToBounds = true
    shadowView.translatesAutoresizingMaskIntoConstraints = false
    
    addAndAttachToEdges(view: shadowView, inset: 10)
  }
  
  private func configureMoveDots() {
    addSubview(moveDotsImageContainer)
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
  
  private func configureStackView(with contact: Contact) {
    stackView?.removeFromSuperview()
    stackView = UIStackView()
    let valuesToShow = [\Contact.fullName,
                        \Contact.jobTitle]
    valuesToShow.forEach { path in
      let text = contact[keyPath: path]
      stackView.addArrangedSubview(makeColumn(text: text))
    }
    shadowView.addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillEqually
  
    stackView.leftAnchor.constraint(equalTo: moveDotsImageContainer.rightAnchor).isActive = true
    stackView.rightAnchor.constraint(equalTo: assignButton.leftAnchor, constant: -8).isActive = true
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
  
  private func configureAssignButton() {
    assignButton.backgroundColor = .brandGreen
    assignButton.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
    assignButton.layer.cornerRadius = 20
    assignButton.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(assignButton)
    
    assignButton.rightAnchor.constraint(equalTo: shadowView.rightAnchor, constant: -8).isActive = true
    assignButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    assignButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    assignButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
  }
  
  @objc
  private func assignButtonTapped() {
    guard let contact = contact else { return }
    delegate?.didClickAssignButton(assignButton, forContact: contact)
  }
}
