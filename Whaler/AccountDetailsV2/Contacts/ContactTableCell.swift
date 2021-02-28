//
//  ContactTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/23/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class ContactTableCell: UITableViewCell, MainCollectionTableCell {
  static var id: String = "ContactTableCellId"
  static let cellHeight: CGFloat = 93.0
  
  var delegate: MainTableCellDelegate?
  private var contact: Contact!
  
  func configure<T>(with object: T) {
    guard let contact = object as? Contact else {
      let message = "Fatal error! Configuring cell with wrong type."
      Log.error(message)
      fatalError(message)
    }
    self.contact = contact
    configureNameLabel()
  }
  
  private func configureNameLabel() {
    let label = UILabel()
    label.text = contact.fullName
    
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
    label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
    label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
    label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
  }
}
