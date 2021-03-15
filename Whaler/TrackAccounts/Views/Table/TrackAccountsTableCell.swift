//
//  TrackAccountsTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

struct TrackAccountsTableData {
  enum Style {
    case content, header
  }
  
  var accountName: String
  var industry: String?
  var billingCity: String?
  var billingState: String?
  var contactCount: String
  var style: TrackAccountsTableData.Style
}

class TrackAccountsTableCell: UITableViewCell {
  static let id = "TrackAccountsTableCellId"
  static let height: CGFloat = 70.0
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    return stackView
  }()
  private lazy var checkbox: CellCheckBox = makeCheckBox(withWidthMultiplier: 33/593, toStackView: stackView)
  private lazy var accountBox: CellTextBox = makeTextBox(withWidthMultiplier: 134/593, toStackView: stackView)
  private lazy var industryBox: CellTextBox = makeTextBox(withWidthMultiplier: 134/593, toStackView: stackView)
  private lazy var cityBox: CellTextBox = makeTextBox(withWidthMultiplier: 112/593, toStackView: stackView)
  private lazy var stateBox: CellTextBox = makeTextBox(withWidthMultiplier: 90/593, toStackView: stackView)
  private lazy var contactsBox: CellTextBox = makeTextBox(withWidthMultiplier: 90/593, toStackView: stackView)
  
  var dataSource: TrackAccountsTableData? {
    didSet {
      setLabelValues(with: dataSource)
    }
  }
  
  var isChecked: Bool = false {
    didSet {
      checkbox.isChecked = isChecked
    }
  }
  
  init() {
    super.init(style: .default, reuseIdentifier: TrackAccountsTableCell.id)
    configure()
  }
  
  init(frame: CGRect) {
    super.init(style: .default, reuseIdentifier: TrackAccountsTableCell.id)
    self.frame = frame
    configure()
  }
  
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
    backgroundColor = .primaryBackground
    
    let bottomLine = UIView()
    bottomLine.backgroundColor = .primaryText
    bottomLine.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addAndAttach(view: bottomLine, height: 2, attachingEdges: [.left(0), .right(0), .bottom(0)])
    
    configureStackView()
  }
  
  private func configureStackView() {
    contentView.addAndAttach(view: stackView, attachingEdges: [.left(0), .top(0), .right(0), .bottom(-2)])
  }
  
  private func makeTextBox(withWidthMultiplier widthMultiplier: CGFloat, toStackView stackView: UIStackView) -> CellTextBox {
    let box = CellTextBox()
    addViewToStackView(view: box, stackView: stackView, withWidthMultiplier: widthMultiplier)
    return box
  }
  
  private func makeCheckBox(withWidthMultiplier widthMultiplier: CGFloat, toStackView stackView: UIStackView) -> CellCheckBox {
    let box = CellCheckBox()
    addViewToStackView(view: box, stackView: stackView, withWidthMultiplier: widthMultiplier)
    return box
  }
  
  private func addViewToStackView(view: UIView, stackView: UIStackView, withWidthMultiplier widthMultiplier: CGFloat) {
    view.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(view)
    
    NSLayoutConstraint.activate([
      view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier),
      view.heightAnchor.constraint(equalTo: heightAnchor),
    ])
  }
  
  private func setLabelValues(with dataSource: TrackAccountsTableData?) {
    guard let dataSource = dataSource else { return }
    let textColor: UIColor
    switch dataSource.style {
    case .header:
      textColor = .secondaryText
    case .content:
      textColor = .primaryText
    }
    
    checkbox.isChecked = false
    
    accountBox.text = dataSource.accountName
    industryBox.text = dataSource.industry ?? "—"
    cityBox.text = dataSource.billingCity ?? "—"
    stateBox.text = dataSource.billingState ?? "—"
    contactsBox.text = dataSource.contactCount
    
    accountBox.textColor = textColor
    industryBox.textColor = textColor
    cityBox.textColor = textColor
    stateBox.textColor = textColor
    contactsBox.textColor = textColor
  }
}
