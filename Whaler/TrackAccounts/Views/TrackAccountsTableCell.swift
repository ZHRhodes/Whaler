//
//  TrackAccountsTableCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/7/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

struct TrackAccountsHeaderData: TrackAccountsDataSource {
  enum Style {
    case content, header
  }
  
  var accountName: String
  var industry: String?
  var billingCity: String?
  var billingState: String?
  var contactCount: String
  var style: TrackAccountsHeaderData.Style
}

protocol TrackAccountsDataSource {
  var accountName: String { get }
  var industry: String? { get }
  var billingCity: String? { get }
  var billingState: String? { get }
  var contactCount: String { get }
  var style: TrackAccountsHeaderData.Style { get }
}

class TrackAccountsTableCell: UITableViewCell {
  static let id = "TrackAccountsTableCellId"
  static let height: CGFloat = 70.0
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    return stackView
  }()
  private var checkbox = UIView()
  private lazy var accountBox: TextBox = makeTextBox(withWidthMultiplier: 1/5, toStackView: stackView)
  private lazy var industryBox: TextBox = makeTextBox(withWidthMultiplier: 1/5, toStackView: stackView)
  private lazy var cityBox: TextBox = makeTextBox(withWidthMultiplier: 1/5, toStackView: stackView)
  private lazy var stateBox: TextBox = makeTextBox(withWidthMultiplier: 1/5, toStackView: stackView)
  private lazy var contactsBox: TextBox = makeTextBox(withWidthMultiplier: 1/5, toStackView: stackView)
  
  var dataSource: TrackAccountsDataSource? {
    didSet {
      setLabelValues(with: dataSource)
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
  
  private func makeTextBox(withWidthMultiplier widthMultiplier: CGFloat, toStackView stackView: UIStackView) -> TextBox {
    let box = TextBox()
    box.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(box)
    
    NSLayoutConstraint.activate([
      box.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier),
      box.heightAnchor.constraint(equalTo: heightAnchor),
    ])
    
    return box
  }
  
  private func setLabelValues(with dataSource: TrackAccountsDataSource?) {
    guard let dataSource = dataSource else { return }
    let textColor: UIColor
    switch dataSource.style {
    case .header:
      textColor = .secondaryText
    case .content:
      textColor = .primaryText
    }
    
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

extension TrackAccountsTableCell {
  private class TextBox: UIView {
    private let label = UILabel()
    
    var text: String? {
      get {
        return label.text
      }
      set {
        label.text = newValue
      }
    }
    
    var textColor: UIColor? {
      get {
        return label.textColor
      }
      set {
        label.textColor = newValue
      }
    }
    
    init() {
      super.init(frame: .zero)
      configure()
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
      configure()
    }
    
    private func configure() {
      let rightLine = UIView()
      rightLine.translatesAutoresizingMaskIntoConstraints = false
      rightLine.backgroundColor = .primaryText
      addSubview(rightLine)
      
      NSLayoutConstraint.activate([
        rightLine.widthAnchor.constraint(equalToConstant: 2.0),
        rightLine.rightAnchor.constraint(equalTo: rightAnchor),
        rightLine.topAnchor.constraint(equalTo: topAnchor),
        rightLine.bottomAnchor.constraint(equalTo: bottomAnchor),
      ])
      
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = .primaryText
      label.font = .openSans(weight: .regular, size: 24)
      addSubview(label)
      
      NSLayoutConstraint.activate([
        label.rightAnchor.constraint(equalTo: rightAnchor),
        label.centerYAnchor.constraint(equalTo: centerYAnchor),
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
        label.heightAnchor.constraint(equalToConstant: 33.0)
      ])
    }
  }
}
