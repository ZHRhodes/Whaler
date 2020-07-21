//
//  MainTableSectionHeader.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit

class MainTableSectionHeader: UITableViewHeaderFooterView {
  static let id = "MainTableSectionHeaderId"
  private var stateTag: AccountStateTagView!
  private var rowView: AccountRowValuesView!
  
  private let spaceFromTagToTop: CGFloat = 32
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    tintColor = .clear
    contentView.backgroundColor = .white
    contentView.heightAnchor.constraint(equalToConstant: AccountStateTagView.height + AccountRowValuesView.height + spaceFromTagToTop).isActive = true
    
    backgroundColor = .white
    clipsToBounds = false
    layer.shadowColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 0.21).cgColor
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 6.0
    layer.shadowOffset = CGSize(width: 0, height: 1)
  }

  func configure(state: WorkState, values: [String]) {
    configureStateTag(with: state)
    configureRowValues(with: values)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureStateTag(with state: WorkState) {
    stateTag?.removeFromSuperview()
    stateTag = AccountStateTagView(state: state)
    stateTag.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stateTag)
    
    let constraints = [
      stateTag.topAnchor.constraint(equalTo: topAnchor, constant: spaceFromTagToTop),
      stateTag.leftAnchor.constraint(equalTo: leftAnchor),
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureRowValues(with values: [String]) {
    rowView?.removeFromSuperview()
    rowView = AccountRowValuesView(values: values)
    rowView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(rowView)
    
    let constraints = [
      rowView.bottomAnchor.constraint(equalTo: bottomAnchor),
      rowView.leftAnchor.constraint(equalTo: leftAnchor),
      rowView.widthAnchor.constraint(equalTo: widthAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
}
