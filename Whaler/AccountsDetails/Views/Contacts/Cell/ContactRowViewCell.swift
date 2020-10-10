//
//  ContactRowViewCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/29/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

protocol ContactRowViewCellDelegate: class {
  func didClickAssignButton(_ button: UIView, forContact contact: Contact)
}

class ContactRowViewCell: UITableViewCell {
  static let id = "ContactRowViewCellID"
  static let height: CGFloat = 70.0
  
  var cellView: ContactRowView!
  weak var delegate: ContactRowViewCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
    
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  private func configure() {
    selectionStyle = .none
  }
  
  func configure(withContact contact: Contact) {
    if cellView == nil {
      configureCellView(with: contact)
    }
    cellView.configure(with: contact)
  }
  
  private func configureCellView(with contact: Contact) {
    cellView = ContactRowView()
    cellView.delegate = self
    addAndAttachToEdges(view: cellView, inset: -4)
  }
}

extension ContactRowViewCell: ContactRowViewDelegate {
  func didClickAssignButton(_ button: UIView, forContact contact: Contact) {
    delegate?.didClickAssignButton(button, forContact: contact)
  }
}
