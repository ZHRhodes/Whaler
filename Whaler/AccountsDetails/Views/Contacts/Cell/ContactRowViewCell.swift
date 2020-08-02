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

class ContactRowViewCell: UITableViewCell {
  static let id = "ContactRowViewCellID"
  var cellView: UIHostingController<ContactRowView>!
  
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
    } else {
      cellView.rootView.contact = contact
    }
  }
  
  private func configureCellView(with contact: Contact) {
    cellView = UIHostingController(rootView: ContactRowView(contact: contact))
    cellView.view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(cellView.view)
    
    let constraints = [
      cellView.view.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
      cellView.view.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
      cellView.view.topAnchor.constraint(equalTo: topAnchor, constant: 4),
      cellView.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
}
