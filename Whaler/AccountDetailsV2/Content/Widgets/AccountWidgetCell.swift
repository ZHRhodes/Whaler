//
//  AccountWidgetCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/20/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class AccountWidgetCell: UICollectionViewCell {
  static let id = "AccountWidgetCellId"
  private var titleLabel: UILabel = UILabel()
  private var content: UIView?
  private lazy var widthConstraint: NSLayoutConstraint = {
    let widthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
    widthConstraint.isActive = true
    widthConstraint.priority = .required
    return widthConstraint
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  private func configure() {
    configureTitleLabel()
    enableContentViewSelfSizing()
  }
  
  private func enableContentViewSelfSizing() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
        contentView.leftAnchor.constraint(equalTo: leftAnchor),
        contentView.rightAnchor.constraint(equalTo: rightAnchor),
        contentView.topAnchor.constraint(equalTo: topAnchor),
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  override func updateConstraints() {
      widthConstraint.constant = superview?.bounds.width ?? 0
      super.updateConstraints()
  }
  
  func setWidth(_ newWidth: CGFloat) {
    widthConstraint.constant = newWidth
  }
  
  private func configureTitleLabel() {
    titleLabel.font = .openSans(weight: .bold, size: 18)
    contentView.addAndAttach(view: titleLabel, height: 24.0, attachingEdges: [.top(), .left(16)])
  }
  
  func configure(title: String, content: UIView) {
    titleLabel.text = title
    self.content?.removeFromSuperview()
    self.content = content
    contentView.addAndAttach(view: content, attachingEdges: [.right(-16),
                                                             .bottom(-16),
                                                             .top(16, equalTo: titleLabel.bottomAnchor)])
    let leftConstraint = content.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
    leftConstraint.priority = .required
    leftConstraint.isActive = true
  }
}
